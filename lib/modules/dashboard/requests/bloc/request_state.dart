import '../models/request_type.dart';

class RequestState {
  final RequestType? selectedType;

  RequestState({this.selectedType});

  RequestState copyWith({RequestType? selectedType}) {
    return RequestState(
      selectedType: selectedType ?? this.selectedType,
    );
  }
}