import '../models/response/get_agents_response_model.dart';

abstract class AgentState {}

class AgentInitial extends AgentState {}

class AgentLoading extends AgentState {}

class AgentLoaded extends AgentState {
  final List<AgentModel> agents;

  AgentLoaded(this.agents);
}

class AgentError extends AgentState {
  final String message;

  AgentError(this.message);
}