enum RequestType {
  footage,
  faceIdentify,
  anpr,
}

extension RequestTypeExtension on RequestType {
  String get title {
    switch (this) {
      case RequestType.footage:
        return "Footage Request";
      case RequestType.faceIdentify:
        return "Face Identify";
      case RequestType.anpr:
        return "ANPR Request";
    }
  }
}