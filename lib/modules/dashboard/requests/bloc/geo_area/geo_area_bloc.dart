import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/get_geo_area.dart';
import 'geo_area_event.dart';
import 'geo_area_state.dart';

class GeoAreaBloc extends Bloc<GeoAreaEvent, GeoAreaState> {
  final GetGeoAreaRepository repository;

  GeoAreaBloc({required this.repository}) : super(GeoAreaInitial()) {
    on<FetchGeoAreas>(_onFetchGeoAreas);
  }

  Future<void> _onFetchGeoAreas(
    FetchGeoAreas event,
    Emitter<GeoAreaState> emit,
  ) async {
    emit(GeoAreaLoading());
    try {
      final response = await repository.getGeoArea();
      emit(GeoAreaLoaded(response));
    } catch (e) {
      emit(GeoAreaError(e.toString()));
    }
  }
}
