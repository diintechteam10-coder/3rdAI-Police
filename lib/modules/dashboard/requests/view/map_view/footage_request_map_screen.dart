import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/geo_area/geo_area_bloc.dart';
import '../../bloc/geo_area/geo_area_state.dart';
import '../../models/area/response/geo_area_response.dart';
import '../../bloc/camera/camera_bloc.dart';
import '../../bloc/camera/camera_state.dart';
import '../../models/camera/response/camera_response_model.dart';
import 'widgets/footage_shimmer_widgets.dart';

class CameraFocusInfo {
  final LatLng location;
  final String cameraId;
  const CameraFocusInfo({required this.location, required this.cameraId});
}

class FootageRequestMapScreen extends StatefulWidget {
  final bool hideAppBar;
  final ValueNotifier<CameraFocusInfo?>? focusLocationNotifier;
  const FootageRequestMapScreen({
    super.key, 
    this.hideAppBar = false,
    this.focusLocationNotifier,
  });

  @override
  State<FootageRequestMapScreen> createState() =>
      _FootageRequestMapScreenState();
}

class _FootageRequestMapScreenState extends State<FootageRequestMapScreen> {
  GoogleMapController? _mapController;
  Set<Polygon> _polygons = {};
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool _isPermissionGranted = false;
  bool _isLoadingPermission = true;
  BitmapDescriptor? _activeCameraIcon;
  BitmapDescriptor? _inactiveCameraIcon;
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  String? _selectedCameraId;
  CameraResponse? _lastCameraData;
  Map<String, Marker> _markerRegistry = {};
  Map<String, Circle> _circleRegistry = {};

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadCameraIcons();
    
    widget.focusLocationNotifier?.addListener(_onFocusLocationChanged);
  }

  void _onFocusLocationChanged() {
    final info = widget.focusLocationNotifier?.value;
    if (info != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: info.location,
            zoom: 20.0,
            tilt: 45,
            bearing: 30,
          ),
        ),
      );

      _setSelectedCamera(info.cameraId);
      _mapController?.showMarkerInfoWindow(MarkerId(info.cameraId));
    }
  }

  void _setSelectedCamera(String cameraId) {
    if (_selectedCameraId == cameraId) return;
    setState(() {
      _selectedCameraId = cameraId;
      _rebuildMarkersAndCircles();
    });
  }

  void _rebuildMarkersAndCircles() {
    // Rebuild markers if registry has data
    if (_markerRegistry.isNotEmpty) {
      _markers = _markerRegistry.values.map((marker) {
        final bool isSelected = marker.markerId.value == _selectedCameraId;
        if (isSelected) {
          return Marker(
            markerId: marker.markerId,
            position: marker.position,
            zIndex: 10,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: marker.infoWindow,
            onTap: marker.onTap,
          );
        }
        return marker;
      }).toSet();
    }

    // Rebuild circles if registry has data
    if (_circleRegistry.isNotEmpty) {
      _circles = _circleRegistry.values.map((circle) {
        final bool isSelected = circle.circleId.value == "circle_$_selectedCameraId";
        if (isSelected) {
          return Circle(
            circleId: circle.circleId,
            center: circle.center,
            radius: circle.radius * 2.5,
            fillColor: circle.fillColor.withValues(alpha: 0.4),
            strokeColor: circle.strokeColor.withValues(alpha: 0.6),
            strokeWidth: 6,
            consumeTapEvents: circle.consumeTapEvents,
          );
        }
        return circle;
      }).toSet();
    }
  }



  @override
  void dispose() {
    widget.focusLocationNotifier?.removeListener(_onFocusLocationChanged);
    super.dispose();
  }

  Future<void> _loadCameraIcons() async {
    _activeCameraIcon = await _createCustomMarker(Colors.green);
    _inactiveCameraIcon = await _createCustomMarker(Colors.red);
    
    if (mounted) {
      setState(() {});
      // Re-create markers if data is already loaded
      final currentState = context.read<CameraBloc>().state;
      if (currentState is CameraLoaded) {
        setState(() {
          _markers = _createMarkers(currentState.data);
          _circles = _createCircles(currentState.data);
        });
      }
    }
  }

  Future<BitmapDescriptor> _createCustomMarker(Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    final double iconSize = 100.0;
    final double radius = 40.0;
    
    // Draw background circle
    final Paint circlePaint = Paint()..color = color.withValues(alpha: 0.9);
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(Offset(iconSize/2, iconSize/2), radius, circlePaint);
    canvas.drawCircle(Offset(iconSize/2, iconSize/2), radius, borderPaint);

    textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.videocam.codePoint),
        style: TextStyle(
            fontSize: 50.0,
            fontFamily: Icons.videocam.fontFamily,
            color: Colors.white));
    textPainter.layout();
    textPainter.paint(canvas, Offset(iconSize/2 - 25, iconSize/2 - 25));
    
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(iconSize.toInt(), iconSize.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return BitmapDescriptor.defaultMarker;
    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }

  Future<void> _checkPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
          _isLoadingPermission = false;
        });
      }
    } else {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.location.request();
    if (mounted) {
      setState(() {
        _isPermissionGranted = status.isGranted;
        _isLoadingPermission = false;
      });
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Required"),
        content: const Text(
          "This app needs location access to show your position on the map. Please enable it in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

void _onMapCreated(GoogleMapController controller) {
  _mapController = controller;

  // Handle pending focus from List View
  final focusData = widget.focusLocationNotifier?.value;

  if (focusData != null) {
    Future.delayed(const Duration(milliseconds: 300), () {
      _onFocusLocationChanged();
    });
  } else {
    // If we already have polygons but no focus, fit the area
    if (_polygons.isNotEmpty) {
      _fitBounds();
    }
  }

  // If we already have camera icons loaded but markers are empty, create them
  if (_activeCameraIcon != null && _markerRegistry.isEmpty) {
    final cameraState = context.read<CameraBloc>().state;
    if (cameraState is CameraLoaded) {
      setState(() {
        _lastCameraData = cameraState.data;
        _createMarkers(cameraState.data);
        _createCircles(cameraState.data);
      });
    }
  }
}



  void _fitBounds() {
    if (_mapController == null || _polygons.isEmpty) return;

    LatLngBounds? bounds;
    for (final polygon in _polygons) {
      for (final point in polygon.points) {
        if (bounds == null) {
          bounds = LatLngBounds(southwest: point, northeast: point);
        } else {
          bounds = LatLngBounds(
            southwest: LatLng(
              point.latitude < bounds.southwest.latitude
                  ? point.latitude
                  : bounds.southwest.latitude,
              point.longitude < bounds.southwest.longitude
                  ? point.longitude
                  : bounds.southwest.longitude,
            ),
            northeast: LatLng(
              point.latitude > bounds.northeast.latitude
                  ? point.latitude
                  : bounds.northeast.latitude,
              point.longitude > bounds.northeast.longitude
                  ? point.longitude
                  : bounds.northeast.longitude,
            ),
          );
        }
      }
    }

    if (bounds != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  Set<Polygon> _createPolygons(GeoJsonResponse data) {
    final Set<Polygon> newPolygons = {};
    for (var feature in data.features) {
      if (feature.geometry.type == 'Polygon') {
        final List<LatLng> points = [];
        if (feature.geometry.coordinates.isNotEmpty) {
          for (var coord in feature.geometry.coordinates.first) {
            if (coord.length >= 2) {
              points.add(LatLng(coord[1], coord[0]));
            }
          }
        }

        newPolygons.add(
          Polygon(
            polygonId: PolygonId(feature.properties.id),
            points: points,
            fillColor: Colors.blue.withValues(alpha: 0.35),
            strokeColor: Colors.blue.shade700,
            strokeWidth: 3,
            consumeTapEvents: true,
            // onTap: () {
            //   _showAreaDetails(feature.properties);
            // },
          ),
        );
      }
    }
    return newPolygons;
  }

Set<Marker> _createMarkers(CameraResponse data) {
  _markerRegistry.clear();
  final features = data.features ?? [];

  for (var feature in features) {
    if (feature.geometry?.coordinates != null &&
        feature.geometry!.coordinates!.length >= 2) {

      final lat = feature.geometry!.latitude!;
      final lng = feature.geometry!.longitude!;
      final isActive = feature.properties?.isActive ?? false;
      final camId = feature.properties?.id ??
          feature.properties?.cameraId ??
          "${lat}_${lng}";

      final marker = Marker(
        markerId: MarkerId(camId),
        position: LatLng(lat, lng),
        icon: isActive
            ? (_activeCameraIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen))
            : (_inactiveCameraIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
        infoWindow: InfoWindow(
          title: feature.properties?.name ?? "Camera",
          snippet: "${isActive ? '🟢 Active' : '🔴 Inactive'}",
        ),
        onTap: () {
          _setSelectedCamera(camId);
          
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, lng),
                zoom: 20.0,
                tilt: 45,
                bearing: 30,
              ),
            ),
          );

          if (feature.properties != null) {
            _showCameraDetails(feature.properties!);
          }
        },
      );
      _markerRegistry[camId] = marker;
    }
  }
  
  _rebuildMarkersAndCircles();
  return _markers;
}

Set<Circle> _createCircles(CameraResponse data) {
  _circleRegistry.clear();
  final features = data.features ?? [];
  for (var feature in features) {
    if (feature.geometry?.coordinates != null &&
        feature.geometry!.coordinates!.length >= 2) {
      final lat = feature.geometry!.latitude!;
      final lng = feature.geometry!.longitude!;
      final isActive = feature.properties?.isActive ?? false;
      final radius = feature.properties?.radius?.toDouble() ?? 100.0;
      final camId = feature.properties?.id ?? feature.properties?.cameraId ?? "${lat}_${lng}";

      final circle = Circle(
        circleId: CircleId("circle_$camId"),
        center: LatLng(lat, lng),
        radius: radius,
        fillColor: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
        strokeColor: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.3),
        strokeWidth: 2,
        consumeTapEvents: false,
      );
      _circleRegistry[camId] = circle;
    }
  }
  _rebuildMarkersAndCircles();
  return _circles;
}


  
  void _showCameraDetails(CameraProperties props) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CameraDetailsDialog(cameraProps: props);
      },
    );
  }

  void _showAreaDetails(Properties props) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        debugPrint("-------------------------------");
        debugPrint("Area Details:");
        debugPrint("Name: ${props.name}");
        debugPrint("City: ${props.city}");
        debugPrint("Partner: ${props.partnerName}");
        debugPrint("Email: ${props.partnerEmail}");
        debugPrint("Description: ${props.description}");
        debugPrint("-------------------------------");
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF111827),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                props.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _detailRow(Icons.location_city, "City", props.city),
              _detailRow(Icons.business, "Partner", props.partnerName),
              _detailRow(Icons.email, "Email", props.partnerEmail),
              // const SizedBox(height: 16),
              // Text(
              //   "Description",
              //   style: TextStyle(
              //     color: Colors.grey.shade400,
              //     fontSize: 14,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(height: 4),
              // Html(data: props.description),
              // Text(
              //   props.description,
              //   style: const TextStyle(color: Colors.white70, fontSize: 15),
              // ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Requesting footage for ${props.name}"),
                      backgroundColor: Colors.blue.shade600,
                    ),
                  );
                },
                child: const Text(
                  "Request Footage",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade400),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = _isLoadingPermission
        ? const MapShimmer()
        : BlocListener<CameraBloc, CameraState>(
            listener: (context, state) {
              if (state is CameraLoaded && state.data != _lastCameraData) {
                setState(() {
                  _lastCameraData = state.data;
                  _createMarkers(state.data);
                  _createCircles(state.data);
                });
              }
            },
            child: BlocBuilder<GeoAreaBloc, GeoAreaState>(
              builder: (context, state) {
                if (state is GeoAreaLoading) {
                  return const MapShimmer();
                } else if (state is GeoAreaError) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is GeoAreaLoaded) {
                  _polygons = _createPolygons(state.data);

                  // Only fit bounds if a camera is NOT currently focused.
                  // This prevents overriding the focus zoom.
                  final hasFocus = widget.focusLocationNotifier?.value != null;
                  if (_mapController != null && !hasFocus) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _fitBounds(),
                    );
                  }

                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(28.6139, 77.2090),
                          zoom: 22,
                        ),
                        onMapCreated: _onMapCreated,
                        polygons: _polygons,
                        markers: _markers,
                        circles: _circles,
                        myLocationEnabled: _isPermissionGranted,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        style: _mapStyle,
                      ),
                      // _buildDraggableSheet(),
                    ],
                  );
                }
                return const Center(child: Text("Preparing map..."));
              },
            ),
          );

    if (widget.hideAppBar) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Select Area for Footage",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF111827),
      ),
      body: bodyContent,
    );
  }

  static const String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#242f3e"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#263c3f"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#6b9a76"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#38414e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#212a37"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9ca5b3"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#746855"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#1f2835"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#f3d19c"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#2f3948"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#d59563"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#515c6d"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#17263c"
      }
    ]
  }
]
''';
}

class CameraDetailsDialog extends StatefulWidget {
  final CameraProperties cameraProps;
  final CameraGeometry? geometry;
  final Function(double lat, double lng, String id)? onShowOnMap;

  const CameraDetailsDialog({
    Key? key, 
    required this.cameraProps,
    this.geometry,
    this.onShowOnMap,
  }) : super(key: key);

  @override
  State<CameraDetailsDialog> createState() => _CameraDetailsDialogState();
}

class _CameraDetailsDialogState extends State<CameraDetailsDialog> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoLoading = true;
  bool _hasVideoError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final videoUrl = widget.cameraProps.videoUrl;
    if (videoUrl != null && videoUrl.isNotEmpty) {
      try {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await _videoPlayerController!.initialize();
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: true,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          errorBuilder: (context, errorMessage) => Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        setState(() {
          _isVideoLoading = false;
        });
      } catch (e) {
        setState(() {
          _isVideoLoading = false;
          _hasVideoError = true;
        });
      }
    } else {
      setState(() {
        _isVideoLoading = false;
        _hasVideoError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.cameraProps.name ?? "Camera Details",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                 
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (widget.cameraProps.locationName != null &&
                  widget.cameraProps.locationName!.isNotEmpty)
                _detailRow(
                    Icons.location_on, "Location", widget.cameraProps.locationName!),
              if (widget.cameraProps.city != null && widget.cameraProps.city!.isNotEmpty)
                _detailRow(Icons.location_city, "City", widget.cameraProps.city!),
              _detailRow(
                Icons.info_outline, 
                "Status", 
                (widget.cameraProps.isActive ?? false) ? "Active" : "Inactive",
                valueColor: (widget.cameraProps.isActive ?? false) ? Colors.green : Colors.red,
              ),
              // if (widget.cameraProps.description != null &&
              //     widget.cameraProps.description!.isNotEmpty)
              //   _detailRow(
              //       Icons.description, "Description", widget.cameraProps.description!),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Live Footage",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   IconButton(
                    onPressed: () {
                      final lat = widget.geometry?.latitude;
                      final lng = widget.geometry?.longitude;
                      final id = widget.cameraProps.id ?? widget.cameraProps.cameraId ?? "";
                      
                      if (lat != null && lng != null && widget.onShowOnMap != null) {
                        Navigator.pop(context);
                        widget.onShowOnMap!(lat, lng, id);
                      }
                    },
                    icon: const Icon(Icons.map_outlined, color: Colors.blueAccent),
                    tooltip: "Show on Map",
                  ),
               
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isVideoLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _hasVideoError || _chewieController == null
                          ? const Center(
                              child: Text(
                                "Video not available",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Chewie(controller: _chewieController!),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Requesting footage for ${widget.cameraProps.name ?? 'Camera'}"),
                      backgroundColor: Colors.blue.shade600,
                    ),
                  );
                },
                child: const Text(
                  "Request Footage",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade400),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: valueColor ?? Colors.white)),
          ),
        ],
      ),
    );
  }
}
