import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/get_geo_camera.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository repository;

  CameraBloc({required this.repository}) : super(CameraInitial()) {
    on<FetchCameras>(_onFetchCameras);
  }

  Future<void> _onFetchCameras(
    FetchCameras event,
    Emitter<CameraState> emit,
  ) async {
    // 1. Try to load and emit from cache first for instant UI
    try {
      final cachedResponse = await repository.getCachedCameras(
        city: event.city,
        name: event.name,
      );
      if (cachedResponse != null) {
        emit(CameraLoaded(cachedResponse, isOffline: true));
      }
    } catch (e) {
      print('Cache fetch failed: $e');
    }

    // 2. Proactive network fetch and update
    // Only show loading if we don't have cached data yet
    if (state is! CameraLoaded) {
      emit(CameraLoading());
    }

    try {
      final response = await repository.getCameras(city: event.city, name: event.name);
      emit(CameraLoaded(response, isOffline: false));
    } catch (e) {
      // If we already have offline data, we might not want to show an error
      // but instead just keep the offline data.
      if (state is! CameraLoaded) {
        emit(CameraError(e.toString()));
      }
    }
  }
}
