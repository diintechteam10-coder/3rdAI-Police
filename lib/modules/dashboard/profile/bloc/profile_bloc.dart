import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/get_profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final response = await repository.getProfile();
        if (response.success) {
          emit(ProfileLoaded(response.data));
        } else {
          emit(const ProfileError('Failed to fetch profile data'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileUpdateLoading());
      try {
        final response = await repository.updateProfile(event.profileData);
        if (response.success) {
          emit(ProfileUpdateSuccess(response.data));
          // Refetch profile to be safe or just emit Loaded with new data
          emit(ProfileLoaded(response.data));
        } else {
          emit(const ProfileError('Failed to update profile data'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
