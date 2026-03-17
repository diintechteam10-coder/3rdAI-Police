// class BasisTypesResponse {
//   final bool? success;
//   final BasisTypesData? data;

//   BasisTypesResponse({
//     this.success,
//     this.data,
//   });

//   factory BasisTypesResponse.fromJson(Map<String, dynamic> json) {
//     return BasisTypesResponse(
//       success: json["success"],
//       data: json["data"] != null
//           ? BasisTypesData.fromJson(json["data"])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "success": success,
//       "data": data?.toJson(),
//     };
//   }
// }
// class BasisTypesData {
//   final List<String>? basisTypes;

//   BasisTypesData({
//     this.basisTypes,
//   });

//   factory BasisTypesData.fromJson(Map<String, dynamic> json) {
//     return BasisTypesData(
//       basisTypes: json["basisTypes"] != null
//           ? List<String>.from(json["basisTypes"])
//           : [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "basisTypes": basisTypes,
//     };
//   }
// }