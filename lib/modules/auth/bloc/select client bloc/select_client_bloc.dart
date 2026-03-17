import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/organization_repository.dart';
import '../../models/get_client_response_model.dart';

abstract class SelectClientEvent {}

class FetchOrganizations extends SelectClientEvent {}

class SelectOrganization extends SelectClientEvent {
  final OrganizationData organization;
  SelectOrganization(this.organization);
}

abstract class SelectClientState {}

class SelectClientInitial extends SelectClientState {}

class SelectClientLoading extends SelectClientState {}

class SelectClientLoaded extends SelectClientState {
  final List<OrganizationData> organizations;
  SelectClientLoaded(this.organizations);
}

class SelectClientError extends SelectClientState {
  final String message;
  SelectClientError(this.message);
}

class SelectClientSuccess extends SelectClientState {}

// Bloc
class SelectClientBloc extends Bloc<SelectClientEvent, SelectClientState> {
  final OrganizationRepository repository;

  SelectClientBloc({required this.repository}) : super(SelectClientInitial()) {
    on<FetchOrganizations>((event, emit) async {
      emit(SelectClientLoading());
      try {
        final response = await repository.fetchOrganizations();
        if (response.success) {
          emit(SelectClientLoaded(response.data));
        } else {
          emit(SelectClientError("Failed to load organizations"));
        }
      } catch (e) {
        emit(SelectClientError(e.toString()));
      }
    });

    on<SelectOrganization>((event, emit) async {
      try {
        await repository.saveClientId(event.organization.clientId);
        print("🏢 SELECTED CLIENT ID: ${event.organization.clientId}");
        emit(SelectClientSuccess());
      } catch (e) {
        emit(SelectClientError("Failed to save selection"));
      }
    });
  }
}
