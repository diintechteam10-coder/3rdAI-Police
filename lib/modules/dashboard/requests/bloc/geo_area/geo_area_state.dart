import 'package:equatable/equatable.dart';
import '../../models/area/response/geo_area_response.dart';

abstract class GeoAreaState extends Equatable {
  const GeoAreaState();

  @override
  List<Object?> get props => [];
}

class GeoAreaInitial extends GeoAreaState {}

class GeoAreaLoading extends GeoAreaState {}

class GeoAreaLoaded extends GeoAreaState {
  final GeoJsonResponse data;
  const GeoAreaLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class GeoAreaError extends GeoAreaState {
  final String message;
  const GeoAreaError(this.message);

  @override
  List<Object?> get props => [message];
}
