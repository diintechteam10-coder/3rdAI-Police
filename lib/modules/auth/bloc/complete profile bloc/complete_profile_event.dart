// abstract class CompleteProfileEvent {
//   const CompleteProfileEvent();
// }

// class CompleteProfileInputChanged extends CompleteProfileEvent {
//   final String field;
//   final String value;

//   const CompleteProfileInputChanged({
//     required this.field,
//     required this.value,
//   });
// }

// class CompleteProfileSubmitted extends CompleteProfileEvent {
//   const CompleteProfileSubmitted();
// }

abstract class CompleteProfileEvent {
  const CompleteProfileEvent();
}

class CompleteProfileInputChanged extends CompleteProfileEvent {

  final String field;
  final String value;

  const CompleteProfileInputChanged({
    required this.field,
    required this.value,
  });
}

class CompleteProfileSubmitted extends CompleteProfileEvent {
  const CompleteProfileSubmitted();
}