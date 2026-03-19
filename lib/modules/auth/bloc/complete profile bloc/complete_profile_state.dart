// class CompleteProfileState {
//   final String email;
//   final String clientId;
//   final String name;
//   final String designation;
//   final String policeId;
//   final String area;
//   final String state;
//   final int experience;
//   final String? errorMessage;
//   final bool isLoading;
//   final bool isSuccess;

//   const CompleteProfileState({
//     this.email = '',
//     this.clientId = '',
//     this.name = '',
//     this.designation = '',
//     this.policeId = '',
//     this.area = '',
//     this.state = '',
//     this.experience = 0,
//     this.errorMessage,
//     this.isLoading = false,
//     this.isSuccess = false,
//   });

//   bool get isValid =>
//       email.isNotEmpty &&
//       name.isNotEmpty &&
//       designation.isNotEmpty &&
//       policeId.isNotEmpty &&
//       area.isNotEmpty &&
//       state.isNotEmpty;
//   // experience could be optional or 0, so leaving it out of required for now, or just require it to be validated later.

//   CompleteProfileState copyWith({
//     String? email,
//     String? clientId,
//     String? name,
//     String? designation,
//     String? policeId,
//     String? area,
//     String? state,
//     int? experience,
//     String? errorMessage,
//     bool? isLoading,
//     bool? isSuccess,
//   }) {
//     return CompleteProfileState(
//       email: email ?? this.email,
//       clientId: clientId ?? this.clientId,
//       name: name ?? this.name,
//       designation: designation ?? this.designation,
//       policeId: policeId ?? this.policeId,
//       area: area ?? this.area,
//       state: state ?? this.state,
//       experience: experience ?? this.experience,
//       errorMessage: errorMessage ?? this.errorMessage,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//     );
//   }
// }



class CompleteProfileState {

  final String email;
  final String clientId;
  final String name;
  final String designation;
  final String policeId;
  final String area;
  final String state;
  final int experience;

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const CompleteProfileState({
    this.email = '',
    this.clientId = '',
    this.name = '',
    this.designation = '',
    this.policeId = '',
    this.area = '',
    this.state = '',
    this.experience = 0,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  bool get isValid =>
      email.isNotEmpty &&
      name.isNotEmpty &&
      designation.isNotEmpty &&
      policeId.isNotEmpty &&
      area.isNotEmpty &&
      state.isNotEmpty;

  CompleteProfileState copyWith({
    String? email,
    String? clientId,
    String? name,
    String? designation,
    String? policeId,
    String? area,
    String? state,
    int? experience,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return CompleteProfileState(
      email: email ?? this.email,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      policeId: policeId ?? this.policeId,
      area: area ?? this.area,
      state: state ?? this.state,
      experience: experience ?? this.experience,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}