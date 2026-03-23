import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../bloc/geo_area/geo_area_bloc.dart';
import '../../bloc/geo_area/geo_area_event.dart';
import '../../bloc/geo_area/geo_area_state.dart';
import '../../models/area/response/geo_area_response.dart';

class FootageRequestMapScreen extends StatefulWidget {
  const FootageRequestMapScreen({super.key});

  @override
  State<FootageRequestMapScreen> createState() =>
      _FootageRequestMapScreenState();
}

class _FootageRequestMapScreenState extends State<FootageRequestMapScreen> {
  GoogleMapController? _mapController;
  Set<Polygon> _polygons = {};
  bool _isPermissionGranted = false;
  bool _isLoadingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    context.read<GeoAreaBloc>().add(FetchGeoAreas());
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
    if (_polygons.isNotEmpty) {
      _fitBounds();
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
            onTap: () {
              _showAreaDetails(feature.properties);
            },
          ),
        );
      }
    }
    return newPolygons;
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Select Area for Footage",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF111827),
      ),
      body: _isLoadingPermission
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<GeoAreaBloc, GeoAreaState>(
              builder: (context, state) {
                if (state is GeoAreaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GeoAreaError) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is GeoAreaLoaded) {
                  _polygons = _createPolygons(state.data);

                  // If map is already created, center it
                  if (_mapController != null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _fitBounds(),
                    );
                  }

                  return GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(28.6139, 77.2090), // Default to Delhi
                      zoom: 12,
                    ),
                    onMapCreated: _onMapCreated,
                    polygons: _polygons,
                    myLocationEnabled: _isPermissionGranted,
                    myLocationButtonEnabled: _isPermissionGranted,
                    zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    style: _mapStyle,
                  );
                }
                return const Center(child: Text("Preparing map..."));
              },
            ),
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
