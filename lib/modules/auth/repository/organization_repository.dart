import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_keys.dart';
import '../../../core/services/api_services.dart';
import '../../../core/services/secure_storage_service.dart';
import '../models/get_client_response_model.dart';

class OrganizationRepository {
  final _dio = ApiService.dio;
  final _storage = SecureStorageService.instance;

  Future<OrganizationResponseModel> fetchOrganizations() async {
    try {
      final response = await _dio.get(ApiConstants.getOrganizations);
      return OrganizationResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveClientId(String clientId) async {
    await _storage.write(key: AppKeys.clientId, value: clientId);
  }

  Future<String?> getSelectedClientId() async {
    return await _storage.read(AppKeys.clientId);
  }
}
