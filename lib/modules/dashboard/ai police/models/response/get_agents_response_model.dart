class AgentResponseModel {
  final bool success;
  final List<AgentModel> data;

  AgentResponseModel({
    required this.success,
    required this.data,
  });

  factory AgentResponseModel.fromJson(Map<String, dynamic> json) {
    return AgentResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => AgentModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
class AgentModel {
  final String id;
  final String displayName;
  final String voiceName;
  final String systemPrompt;
  final String firstMessage;
  final String description;

  AgentModel({
    required this.id,
    required this.displayName,
    required this.voiceName,
    required this.systemPrompt,
    required this.firstMessage,
    required this.description,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: json['_id'] ?? '',
      displayName: json['displayName'] ?? '',
      voiceName: json['voiceName'] ?? '',
      systemPrompt: json['systemPrompt'] ?? '',
      firstMessage: json['firstMessage'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName,
      'voiceName': voiceName,
      'systemPrompt': systemPrompt,
      'firstMessage': firstMessage,
      'description': description,
    };
  }
}