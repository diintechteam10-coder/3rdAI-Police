// import 'package:dio/dio.dart';

// import '../../../../core/constants/api_constants.dart';
// import '../../../../core/services/api_services.dart';
// import '../models/citizen/response/basis_response_model.dart';

// class GetBasisTypesRepository {
//   final Dio _dio = ApiService.dio;

//   Future<BasisTypesResponse> getBasisTypes(String category) async {
//     print("Basis Types API category: $category");
//     final response = await _dio.get(
//       ApiConstants.partnerBasisTypes,
//       queryParameters: {
//         "category": category,
//       },
//       options: Options(extra: {'skipClientId': true}),
//     );

//     return BasisTypesResponse.fromJson(response.data);
//   }
// }