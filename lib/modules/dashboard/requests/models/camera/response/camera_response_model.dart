class CameraResponse {
  final String? type;
  final List<CameraFeature>? features;

  CameraResponse({
    this.type,
    this.features,
  });

  factory CameraResponse.fromJson(Map<String, dynamic> json) {
    return CameraResponse(
      type: json['type'],
      features: (json['features'] as List?)
          ?.map((e) => CameraFeature.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'features': features?.map((e) => e.toJson()).toList(),
    };
  }
}
class CameraFeature {
  final String? type;
  final CameraProperties? properties;
  final CameraGeometry? geometry;

  CameraFeature({
    this.type,
    this.properties,
    this.geometry,
  });

  factory CameraFeature.fromJson(Map<String, dynamic> json) {
    return CameraFeature(
      type: json['type'],
      properties: json['properties'] != null
          ? CameraProperties.fromJson(json['properties'])
          : null,
      geometry: json['geometry'] != null
          ? CameraGeometry.fromJson(json['geometry'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties?.toJson(),
      'geometry': geometry?.toJson(),
    };
  }
}

class CameraProperties {
  final String? id;
  final String? cameraId;
  final String? name;
  final String? locationName;
  final String? city;
  final int? radius;
  final String? description;
  final bool? isActive;
  final String? videoUrl;

  CameraProperties({
    this.id,
    this.cameraId,
    this.name,
    this.locationName,
    this.city,
    this.radius,
    this.description,
    this.isActive,
    this.videoUrl,
  });

  factory CameraProperties.fromJson(Map<String, dynamic> json) {
    return CameraProperties(
      id: json['id'],
      cameraId: json['cameraId'],
      name: json['name'],
      locationName: json['locationName'],
      city: json['city'],
      radius: json['radius'],
      description: json['description'],
      isActive: json['isActive'],
      videoUrl: json['videoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cameraId': cameraId,
      'name': name,
      'locationName': locationName,
      'city': city,
      'radius': radius,
      'description': description,
      'isActive': isActive,
      'videoUrl': videoUrl,
    };
  }
}
class CameraGeometry {
  final String? type;
  final List<double>? coordinates;

  CameraGeometry({
    this.type,
    this.coordinates,
  });

  factory CameraGeometry.fromJson(Map<String, dynamic> json) {
    return CameraGeometry(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  /// Helper methods (VERY IMPORTANT for map)
  double? get latitude =>
      coordinates != null && coordinates!.length > 1 ? coordinates![1] : null;

  double? get longitude =>
      coordinates != null && coordinates!.isNotEmpty ? coordinates![0] : null;
}