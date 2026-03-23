import 'package:equatable/equatable.dart';

abstract class GeoAreaEvent extends Equatable {
  const GeoAreaEvent();

  @override
  List<Object?> get props => [];
}

class FetchGeoAreas extends GeoAreaEvent {}
