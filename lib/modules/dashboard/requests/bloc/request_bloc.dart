import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_event.dart';
import 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestState()) {
    on<SelectRequest>((event, emit) {
      emit(state.copyWith(selectedType: event.type));
    });
  }
}