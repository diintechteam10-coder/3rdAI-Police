abstract class UploadPicEvent {
  const UploadPicEvent();
}

class PickImageFromCamera extends UploadPicEvent {}

class PickImageFromGallery extends UploadPicEvent {}

class UploadImageRequested extends UploadPicEvent {}

class RemoveImageRequested extends UploadPicEvent {}