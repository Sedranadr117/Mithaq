class EndPoints {
  static const String baserUrl = "http://89.116.236.10:3200/api/v1/";

  static const String template = "template/";

  static const String logIn = "citizens/login";
  static const String register = "citizens/register";
  static const String verifyOtp = "citizens/verify-otp";
  static const String reSendOtp = "citizens/resend-otp";
  static const String logout = "auth/logout";
  static const String complaints = "complaints";
  static const String complaintsFilter = "complaints/filter";
  static const String notifications = "notifications";
  static const String registerToken = "notifications/register-token";
  static const String unRegisterToken = "notifications/unregister-token";
  static const String infoRequests = "info-requests";
}

class ApiKeys {
  // Common
  static const String id = "id";
  static const String token = "token";
  static const String email = "email";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String isActive = "isActive";

  // Notification
  static const String title = "title";
  static const String body = "body";
  static const String notificationType = "notificationType";
  static const String sentAt = "sentAt";
  static const String readAt = "readAt";
  static const String status = "status";
  static const String deviceToken = "deviceToken";
  static const String deviceType = "deviceType";

  // Pagination
  static const String page = "page";
  static const String size = "size";
  static const String totalElements = "totalElements";
  static const String totalPages = "totalPages";
  static const String hasNext = "hasNext";
  static const String hasPrevious = "hasPrevious";
  static const String content = "content";
}
