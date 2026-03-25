import 'package:equatable/equatable.dart';
import '../../models/camera/response/camera_response_model.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final CameraResponse data;
  final bool isOffline;
  const CameraLoaded(this.data, {this.isOffline = false});

  @override
  List<Object?> get props => [data, isOffline];
}

class CameraError extends CameraState {
  final String message;
  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
