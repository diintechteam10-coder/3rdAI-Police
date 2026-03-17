import '../models/request_type.dart';

abstract class RequestEvent {}

class SelectRequest extends RequestEvent {
  final RequestType type;
  SelectRequest(this.type);
}