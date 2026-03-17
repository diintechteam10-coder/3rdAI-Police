import 'package:equatable/equatable.dart';
import '../models/response/profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final PartnerData partnerData;

  const ProfileLoaded(this.partnerData);

  @override
  List<Object?> get props => [partnerData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final PartnerData partnerData;

  const ProfileUpdateSuccess(this.partnerData);

  @override
  List<Object?> get props => [partnerData];
}
