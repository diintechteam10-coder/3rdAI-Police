import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'footage_request_map_screen.dart' show FootageRequestMapScreen, CameraFocusInfo;
import 'footage_request_list_screen.dart';
import '../../bloc/camera/camera_bloc.dart';
import '../../bloc/camera/camera_event.dart';
import '../../bloc/geo_area/geo_area_bloc.dart';
import '../../bloc/geo_area/geo_area_event.dart';
import '../../bloc/geo_area/geo_area_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FootageRequestTabsScreen extends StatefulWidget {
  const FootageRequestTabsScreen({super.key});

  @override
  State<FootageRequestTabsScreen> createState() => _FootageRequestTabsScreenState();
}

class _FootageRequestTabsScreenState extends State<FootageRequestTabsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<CameraFocusInfo?> _focusLocationNotifier = ValueNotifier<CameraFocusInfo?>(null);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Whenever the user goes to List View (index 0), reset focus.
      if (!_tabController.indexIsChanging && _tabController.index == 0) {
        _focusLocationNotifier.value = null;
      }
    });
    context.read<GeoAreaBloc>().add(FetchGeoAreas());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusLocationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GeoAreaBloc, GeoAreaState>(
      listener: (context, state) {
        if (state is GeoAreaLoaded && state.data.features.isNotEmpty) {
          final props = state.data.features.first.properties;
          context.read<CameraBloc>().add(FetchCameras(
            city: props.city,
            name: props.name,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111827),
        appBar: AppBar(
          backgroundColor: const Color(0xFF111827),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Select Area for Footage",
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "List View"),
              Tab(text: "Map View"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FootageRequestListScreen(onCameraSelected: (lat, lng, id) {
              // Force update to handle same-camera re-selection
              _focusLocationNotifier.value = null;
              _focusLocationNotifier.value = CameraFocusInfo(location: LatLng(lat, lng), cameraId: id);
              _tabController.animateTo(1);
            }),
            FootageRequestMapScreen(
              hideAppBar: true, 
              focusLocationNotifier: _focusLocationNotifier
            ),
          ],
        ),
      ),
    );
  }
}
