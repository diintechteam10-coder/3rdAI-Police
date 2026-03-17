import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_services.dart';
import '../models/complete profile/request/upload_profile_pic.dart';
import '../models/complete profile/response/upload_profile_pic_response.dart';

class UploadProfileImageRepo {

  final _dio = ApiService.dio;

  Future<UploadProfileImageResponseModel> uploadProfileImage(
      UploadProfileImageRequest request) async {

    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        request.image.path,
        filename: request.image.path.split('/').last,
      ),
    });

    final response = await _dio.post(
      ApiConstants.uploadProfilePic,
      data: formData,
      options: Options(extra: {"skipClientId": true})
    );

    return UploadProfileImageResponseModel.fromJson(response.data);
  }
}