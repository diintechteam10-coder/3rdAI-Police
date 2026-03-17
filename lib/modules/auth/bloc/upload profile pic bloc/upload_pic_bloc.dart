import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../repository/upload_profile_pic_repo.dart';
import '../../models/complete profile/request/upload_profile_pic.dart';
import 'upload_pic_event.dart';
import 'upload_pic_state.dart';

class UploadPicBloc extends Bloc<UploadPicEvent, UploadPicState> {
  final ImagePicker picker = ImagePicker();
  final UploadProfileImageRepo uploadRepo;

  UploadPicBloc({required this.uploadRepo}) : super(const UploadPicState()) {
    /// 🔥 Camera Handler
    on<PickImageFromCamera>((event, emit) async {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (picked != null) {
        emit(state.copyWith(imageFile: File(picked.path)));
      }
    });

    /// 🔥 Gallery Handler
    on<PickImageFromGallery>((event, emit) async {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null) {
        emit(state.copyWith(imageFile: File(picked.path)));
      }
    });

    /// 🔥 Upload Handler
    on<UploadImageRequested>((event, emit) async {
      if (state.imageFile == null) return;

      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        final request = UploadProfileImageRequest(image: state.imageFile!);
        final response = await uploadRepo.uploadProfileImage(request);

        if (response.success == true) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.message ?? 'Image upload failed',
            ),
          );
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
