class CompleteProfileRequestModel {
  final String email;
  final String clientId;
  final String name;
  final String designation;
  final String policeId;
  final String area;
  final String state;
  final int experience;

  CompleteProfileRequestModel({
    required this.email,
    required this.clientId,
    required this.name,
    required this.designation,
    required this.policeId,
    required this.area,
    required this.state,
    required this.experience,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "clientId": clientId,
      "name": name,
      "designation": designation,
      "policeId": policeId,
      "area": area,
      "state": state,
      "experience": experience,
    };
  }

  factory CompleteProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return CompleteProfileRequestModel(
      email: json['email'],
      clientId: json['clientId'],
      name: json['name'],
      designation: json['designation'],
      policeId: json['policeId'],
      area: json['area'],
      state: json['state'],
      experience: json['experience'],
    );
  }
}