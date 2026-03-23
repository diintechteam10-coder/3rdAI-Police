class GeoJsonResponse {
  final String type;
  final List<Feature> features;

  GeoJsonResponse({
    required this.type,
    required this.features,
  });

  factory GeoJsonResponse.fromJson(Map<String, dynamic> json) {
    return GeoJsonResponse(
      type: json['type'] ?? '',
      features: (json['features'] as List)
          .map((e) => Feature.fromJson(e))
          .toList(),
    );
  }
}
class Feature {
  final String type;
  final Properties properties;
  final Geometry geometry;

  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json['type'] ?? '',
      properties: Properties.fromJson(json['properties']),
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}
class Properties {
  final String id;
  final String name;
  final String city;
  final String partnerName;
  final String partnerEmail;
  final String description;

  Properties({
    required this.id,
    required this.name,
    required this.city,
    required this.partnerName,
    required this.partnerEmail,
    required this.description,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      partnerName: json['partnerName'] ?? '',
      partnerEmail: json['partnerEmail'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
class Geometry {
  final String type;
  final List<List<List<double>>> coordinates;

  Geometry({
    required this.type,
    required this.coordinates,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List)
          .map<List<List<double>>>(
            (polygon) => (polygon as List)
                .map<List<double>>(
                  (point) => List<double>.from(point),
                )
                .toList(),
          )
          .toList(),
    );
  }
}