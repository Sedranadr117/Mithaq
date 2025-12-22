class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});
  factory ErrorModel.fromJson(Map jsonData) {
    // Handle both "Message" and "message" fields (case-insensitive)
    final message =
        jsonData["Message"] ??
        jsonData["message"] ??
        jsonData["errorMessage"] ??
        jsonData["Error"] ??
        'An error occurred';

    // Handle status as either int or string
    int statusCode = 500; // Default to 500 if status cannot be determined
    final statusValue = jsonData["status"];
    if (statusValue is int) {
      statusCode = statusValue;
    } else if (statusValue is String) {
      // Try to parse status codes from common error strings
      if (statusValue.contains('500') ||
          statusValue.toUpperCase().contains('INTERNAL_SERVER_ERROR')) {
        statusCode = 500;
      } else if (statusValue.contains('400') ||
          statusValue.toUpperCase().contains('BAD_REQUEST')) {
        statusCode = 400;
      } else if (statusValue.contains('401') ||
          statusValue.toUpperCase().contains('UNAUTHORIZED')) {
        statusCode = 401;
      } else if (statusValue.contains('403') ||
          statusValue.toUpperCase().contains('FORBIDDEN')) {
        statusCode = 403;
      } else if (statusValue.contains('404') ||
          statusValue.toUpperCase().contains('NOT_FOUND')) {
        statusCode = 404;
      } else {
        // Try to extract number from string
        final match = RegExp(r'\d+').firstMatch(statusValue);
        if (match != null) {
          statusCode = int.tryParse(match.group(0) ?? '500') ?? 500;
        }
      }
    }

    return ErrorModel(errorMessage: message.toString(), status: statusCode);
  }
}
