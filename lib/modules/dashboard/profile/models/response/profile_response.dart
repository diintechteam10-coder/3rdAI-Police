class PartnerProfileResponse {
  final bool success;
  final PartnerData data;

  PartnerProfileResponse({
    required this.success,
    required this.data,
  });

  factory PartnerProfileResponse.fromJson(Map<String, dynamic> json) {
    return PartnerProfileResponse(
      success: json['success'] ?? false,
      data: PartnerData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data.toJson(),
    };
  }
}

class PartnerData {
  final String id;
  final String email;
  final String phone;
  final String designation;
  final String policeId;
  final String policeStation;
  final String? profilePicture;
  final String? profilePictureKey;
  final int experience;
  final bool isActive;
  final bool isVerified;
  final String verificationStatus;
  final String name;
  final Location location;

  PartnerData({
    required this.id,
    required this.email,
    required this.phone,
    required this.designation,
    required this.policeId,
    required this.policeStation,
    this.profilePicture,
    this.profilePictureKey,
    required this.experience,
    required this.isActive,
    required this.isVerified,
    required this.verificationStatus,
    required this.name,
    required this.location,
  });

  factory PartnerData.fromJson(Map<String, dynamic> json) {
    return PartnerData(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      designation: json['designation'] ?? '',
      policeId: json['policeId'] ?? '',
      policeStation: json['policeStation'] ?? '',
      profilePicture: json['profilePicture'],
      profilePictureKey: json['profilePictureKey'],
      experience: json['experience'] ?? 0,
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
      verificationStatus: json['verificationStatus'] ?? '',
      name: json['name'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "phone": phone,
      "designation": designation,
      "policeId": policeId,
      "policeStation": policeStation,
      "profilePicture": profilePicture,
      "profilePictureKey": profilePictureKey,
      "experience": experience,
      "isActive": isActive,
      "isVerified": isVerified,
      "verificationStatus": verificationStatus,
      "name": name,
      "location": location.toJson(),
    };
  }
}

class Location {
  final Coordinates coordinates;
  final String area;
  final String state;
  final String? city;
  final String? country;

  Location({
    required this.coordinates,
    required this.area,
    required this.state,
    this.city,
    this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: Coordinates.fromJson(json['coordinates'] ?? {}),
      area: json['area'] ?? '',
      state: json['state'] ?? '',
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coordinates": coordinates.toJson(),
      "area": area,
      "state": state,
      "city": city,
      "country": country,
    };
  }
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  Coordinates({
    this.latitude,
    this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}