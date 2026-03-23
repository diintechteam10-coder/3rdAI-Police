import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../models/complete profile/request/complete_profile_request_model.dart';
import '../../repository/complete_profile_repo.dart';
import 'complete_profile_event.dart';
import 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final CompleteProfileRepo completeProfileRepo;

  CompleteProfileBloc({
    required this.completeProfileRepo,
    String initialEmail = '',
  }) : super(
         CompleteProfileState(email: initialEmail),
       ) {
    /// INPUT CHANGE
    on<CompleteProfileInputChanged>((event, emit) {
      switch (event.field) {
        case 'name':
          emit(state.copyWith(name: event.value));
          break;

        case 'email':
          emit(state.copyWith(email: event.value));
          break;

        case 'designation':
          emit(state.copyWith(designation: event.value));
          break;

        case 'policeId':
          emit(state.copyWith(policeId: event.value));
          break;

        case 'area':
          emit(state.copyWith(area: event.value));
          break;

        case 'state':
          emit(state.copyWith(state: event.value));
          break;

        case 'experience':
          emit(state.copyWith(experience: int.tryParse(event.value) ?? 0));
          break;
      }
    });

    /// SUBMIT
    on<CompleteProfileSubmitted>((event, emit) async {
      if (!state.isValid) return;

      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final storage = SecureStorageService.instance;
        final clientId = await storage.read(AppKeys.clientId) ?? "778205";

        final request = CompleteProfileRequestModel(
          email: state.email,
          clientId: clientId,
          name: state.name,
          designation: state.designation,
          policeId: state.policeId,
          area: state.area,
          state: state.state,
          experience: state.experience,
        );

        final response = await completeProfileRepo.completeprofile(request);

        if (response.success == true) {
          if (response.data?.token != null) {
            final token = response.data!.token!;
            await SecureStorageService.instance.write(
              key: AppKeys.token,
              value: token,
            );
            print("🚀 --- TOKEN SAVED IN SECURE STORAGE --- 🚀");
            print(token);
            print("-----------------------------------------");
          }

          // Save email for status checks
          await SecureStorageService.instance.write(
            key: AppKeys.email,
            value: state.email,
          );

          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.message ?? "Profile completion failed",
            ),
          );
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
