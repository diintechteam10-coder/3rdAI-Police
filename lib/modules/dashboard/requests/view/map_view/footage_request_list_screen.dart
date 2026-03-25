import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/camera/camera_bloc.dart';
import '../../bloc/camera/camera_event.dart';
import '../../bloc/camera/camera_state.dart';
import '../../bloc/geo_area/geo_area_bloc.dart';
import '../../bloc/geo_area/geo_area_state.dart';
import 'widgets/footage_shimmer_widgets.dart';
import 'footage_request_map_screen.dart' show CameraDetailsDialog;

class FootageRequestListScreen extends StatelessWidget {
  final Function(double, double, String)? onCameraSelected;
  const FootageRequestListScreen({super.key, this.onCameraSelected});

  @override
  Widget build(BuildContext context) {
    final geoState = context.watch<GeoAreaBloc>().state;
    
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraLoading || geoState is GeoAreaLoading) {
          return const CameraListShimmer();
        } else if (state is CameraError) {
          return Center(
            child: Text(
              "Error: ${state.message}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is CameraLoaded) {
          final cameras = state.data.features ?? [];
          if (cameras.isEmpty) {
            return const Center(
              child: Text(
                "No cameras found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return RefreshIndicator(
            color: Colors.blue,
            backgroundColor: const Color(0xFF1F2937),
            onRefresh: () async {
               // Get current area details from GeoAreaBloc
               final geoState = context.read<GeoAreaBloc>().state;
               if (geoState is GeoAreaLoaded && geoState.data.features.isNotEmpty) {
                 final props = geoState.data.features.first.properties;
                 context.read<CameraBloc>().add(FetchCameras(
                   city: props.city,
                   name: props.name,
                 ));
                 
                 // Small delay to show indicator (important for responsiveness)
                 await Future.delayed(const Duration(milliseconds: 500));
               }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cameras.length,
              physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
              itemBuilder: (context, index) {
                final feature = cameras[index];
                final camera = feature.properties;
                if (camera == null) return const SizedBox.shrink();

                final bool isActive = camera.isActive ?? false;

                return Card(
                  color: const Color(0xFF1F2937),
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isActive ? Colors.green.withValues(alpha: 0.3) : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.videocam, 
                            color: isActive ? Colors.blue : Colors.grey,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1F2937), width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      camera.name ?? "Unknown Camera",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_city, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                camera.city ?? "Unknown City",
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.map_outlined, color: Colors.blueAccent),
                          onPressed: () {
                            final lat = feature.geometry?.latitude;
                            final lng = feature.geometry?.longitude;
                            final camId = camera.id ?? camera.cameraId ?? "";
                            if (lat != null && lng != null && onCameraSelected != null) {
                              print("DEBUG: Selecting Camera from List - Lat: $lat, Lng: $lng, Id: $camId");
                              onCameraSelected!(lat, lng, camId);
                            }
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => CameraDetailsDialog(
                          cameraProps: camera,
                          geometry: feature.geometry,
                          onShowOnMap: (lat, lng, id) {
                            if (onCameraSelected != null) {
                              onCameraSelected!(lat, lng, id);
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: Text(
            "Select an area on the Map to view cameras",
            style: TextStyle(color: Colors.white54),
          ),
        );
      },
    );
  }
}
