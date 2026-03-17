import 'dart:io';

class UploadPicState {
  final File? imageFile;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const UploadPicState({
    this.imageFile,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  UploadPicState copyWith({
    File? imageFile,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return UploadPicState(
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
