class ApiConstants {
  static const String baseUrl = "https://stage.3rdai.co/api/";
  // static const String baseUrl =
  //     "https://threerdai-backend-5nvu.onrender.com/api/";

  static const String sendEmialOtp = "${baseUrl}mobile/partner/register/step1";
  static const String checkEmail =
      "${baseUrl}mobile/partner/register/step1/google";
  static const String verifyEmailOtp =
      "${baseUrl}mobile/partner/register/step1/verify";
  static const String sendMobileOtp = "${baseUrl}mobile/partner/register/step2";
  static const String resendEmailOtp =
      "${baseUrl}mobile/partner/register/resend-email-otp";
  static const String resendMobileOtp =
      "${baseUrl}mobile/partner/register/step2/resend";
  static const String verifyMobileOtp =
      "${baseUrl}mobile/partner/register/step2/verify";
  static const String completeProfile =
      "${baseUrl}mobile/partner/register/step3";
  static const String uploadProfilePic =
      "${baseUrl}mobile/partner/register/step4";
  static const String googleLogin = "${baseUrl}mobile/partner/register/step1/google";
  static const String login = "${baseUrl}partners/login";
  static const String getOrganizations = "${baseUrl}public/clients/778205";
  static const String getProfile = "${baseUrl}partners/profile";
  static const String getAllAssignedCitizenAlerts = "${baseUrl}alerts/partner";
  static const String partnerBasisTypes =
      "${baseUrl}alerts/partner/basis-types";
  static const String updateAlertStatus = "${baseUrl}alerts/partner";
  static const String getAgents = "${baseUrl}mobile/agents";
  static const String createChat = "${baseUrl}mobile/chat";
  static const String sendMessage =
      "${baseUrl}mobile/chat"; // append /{chatId}/message
  static const String getChatHistory =
      "${baseUrl}mobile/chat"; // append /{chatId}
  static const String getAllChats = "${baseUrl}mobile/chat";
  static const String wsBaseUrl = "wss://stage.3rdai.co/api/voice/agent";

  // Voice Call
  static const String healthCheck = "${baseUrl}health";
  static const String voiceStart = "${baseUrl}mobile/voice/start";
  static const String voiceProcess = "${baseUrl}mobile/voice/process";
}
