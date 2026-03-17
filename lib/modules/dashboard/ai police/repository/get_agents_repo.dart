import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_services.dart';
import '../models/response/get_agents_response_model.dart';

class GetAgentsRepository {
  final Dio _dio = ApiService.dio;

  Future<AgentResponseModel> getAgents() async {
    final response = await _dio.get(
      ApiConstants.getAgents,
      options: Options(
        extra: {'skipClientId': true},
      ),
    );

    return AgentResponseModel.fromJson(response.data);
  }
}