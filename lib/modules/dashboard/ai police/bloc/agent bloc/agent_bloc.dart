import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/get_agents_repo.dart';
import 'agent_event.dart';
import 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final GetAgentsRepository repository;

  AgentBloc(this.repository) : super(AgentInitial()) {
    on<GetAgentsEvent>(_onGetAgents);
  }

  Future<void> _onGetAgents(
    GetAgentsEvent event,
    Emitter<AgentState> emit,
  ) async {
    emit(AgentLoading());

    try {
      final response = await repository.getAgents();

      if (response.success) {
        emit(AgentLoaded(response.data));
      } else {
        emit(AgentError("Failed to load agents"));
      }
    } catch (e) {
      emit(AgentError(e.toString()));
    }
  }
}