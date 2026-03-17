import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final data = await repository.fetchHomeData();

      emit(state.copyWith(
        isLoading: false,
        alerts: data["alerts"],
        requests: data["requests"],
        feedback: data["feedback"],
        banners: data["banners"],
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}