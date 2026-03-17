class OrganizationResponseModel {
  final bool success;
  final List<OrganizationData> data;

  OrganizationResponseModel({
    required this.success,
    required this.data,
  });

  factory OrganizationResponseModel.fromJson(Map<String, dynamic> json) {
    return OrganizationResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => OrganizationData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class OrganizationData {
  final String id;
  final String organizationName;
  final String state;
  final String city;
  final String address;
  final String contactNumber;
  final String alternateContact;
  final String cityBoundary;
  final bool isActive;
  final bool loginApproved;
  final String clientId;
  final String label;

  OrganizationData({
    required this.id,
    required this.organizationName,
    required this.state,
    required this.city,
    required this.address,
    required this.contactNumber,
    required this.alternateContact,
    required this.cityBoundary,
    required this.isActive,
    required this.loginApproved,
    required this.clientId,
    required this.label,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    return OrganizationData(
      id: json['_id'] ?? '',
      organizationName: json['organizationName'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      alternateContact: json['alternateContact'] ?? '',
      cityBoundary: json['cityBoundary'] ?? '',
      isActive: json['isActive'] ?? false,
      loginApproved: json['loginApproved'] ?? false,
      clientId: json['clientId'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "organizationName": organizationName,
      "state": state,
      "city": city,
      "address": address,
      "contactNumber": contactNumber,
      "alternateContact": alternateContact,
      "cityBoundary": cityBoundary,
      "isActive": isActive,
      "loginApproved": loginApproved,
      "clientId": clientId,
      "label": label,
    };
  }
}