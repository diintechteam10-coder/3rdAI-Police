import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class FetchCameras extends CameraEvent {
  final String? city;
  final String? name;

  const FetchCameras({this.city, this.name });

  @override
  List<Object?> get props => [city, name];
}
