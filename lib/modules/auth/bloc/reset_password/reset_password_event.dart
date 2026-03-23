abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String resetToken;
  final String newPassword;

  ResetPasswordSubmitted({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });
}
