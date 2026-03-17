import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/complete profile/request/complete_profile_request_model.dart';
import '../models/complete profile/response/complete_profile_response_model.dart';

class CompleteProfileRepo {
  final _dio = ApiService.dio;
  Future<CompleteProfileResponse> completeprofile(CompleteProfileRequestModel request) async {
    final response = await _dio.post(
      ApiConstants.completeProfile,
      data: request.toJson(),
    );
    return CompleteProfileResponse.fromJson(response.data);
  }
}
