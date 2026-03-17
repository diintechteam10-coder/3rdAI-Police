import 'package:dio/dio.dart';
import 'package:thirdai/modules/auth/models/login/responses/login_response_model.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/login/requests/login_request_model.dart';
class LoginRepository {
  final _dio = ApiService.dio;
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
      options: Options(extra: {"skipClientId": true})
    );
    return LoginResponseModel.fromJson(response.data);
  }
}
