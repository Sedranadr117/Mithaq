import 'dart:io';

import 'package:complaint_app/core/errors/error_model.dart';
import 'package:dio/dio.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

class ConflictException extends ServerException {
  ConflictException(super.errorModel);
}

class BadRequestException extends ServerException {
  BadRequestException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      if (e.response != null && e.response!.data != null) {
        throw ConnectionErrorException(ErrorModel.fromJson(e.response!.data));
      }

      // Check for SocketException (connection abort, network issues)
      String errorMessage = 'Connection error: ${e.message ?? "Unknown error"}';

      if (e.error is SocketException) {
        final socketError = e.error as SocketException;
        if (socketError.message.contains('Software caused connection abort') ||
            socketError.message.contains('Connection aborted')) {
          errorMessage =
              'تم قطع الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
        } else if (socketError.message.contains('Connection refused')) {
          errorMessage =
              'لا يمكن الاتصال بالخادم. يرجى المحاولة مرة أخرى لاحقاً.';
        } else if (socketError.message.contains('Network is unreachable')) {
          errorMessage =
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';
        } else {
          errorMessage =
              'خطأ في الاتصال: ${socketError.message}. يرجى المحاولة مرة أخرى.';
        }
      } else if (e.message != null) {
        if (e.message!.contains('Software caused connection abort') ||
            e.message!.contains('Connection aborted')) {
          errorMessage =
              'تم قطع الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
        } else if (e.message!.contains('Connection refused')) {
          errorMessage =
              'لا يمكن الاتصال بالخادم. يرجى المحاولة مرة أخرى لاحقاً.';
        } else if (e.message!.contains('Network is unreachable') ||
            e.message!.contains('No Internet connection')) {
          errorMessage =
              'لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';
        }
      }

      throw ConnectionErrorException(
        ErrorModel(status: 0, errorMessage: errorMessage),
      );
    case DioExceptionType.badCertificate:
      if (e.response != null && e.response!.data != null) {
        throw BadCertificateException(ErrorModel.fromJson(e.response!.data));
      }
      throw BadCertificateException(
        ErrorModel(
          status: 0,
          errorMessage: 'Bad certificate: ${e.message ?? "Unknown error"}',
        ),
      );
    case DioExceptionType.connectionTimeout:
      if (e.response != null && e.response!.data != null) {
        throw ConnectionTimeoutException(ErrorModel.fromJson(e.response!.data));
      }
      throw ConnectionTimeoutException(
        ErrorModel(
          status: 408,
          errorMessage:
              'انتهت مهلة الاتصال. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.',
        ),
      );

    case DioExceptionType.receiveTimeout:
      if (e.response != null && e.response!.data != null) {
        throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data));
      }
      throw ReceiveTimeoutException(
        ErrorModel(
          status: 408,
          errorMessage: 'انتهت مهلة استلام الاستجابة. يرجى المحاولة مرة أخرى.',
        ),
      );

    case DioExceptionType.sendTimeout:
      if (e.response != null && e.response!.data != null) {
        throw SendTimeoutException(ErrorModel.fromJson(e.response!.data));
      }
      throw SendTimeoutException(
        ErrorModel(
          status: 408,
          errorMessage: 'انتهت مهلة إرسال الطلب. يرجى المحاولة مرة أخرى.',
        ),
      );

    case DioExceptionType.badResponse:
      if (e.response == null) {
        throw BadResponseException(
          ErrorModel(status: 500, errorMessage: 'No response from server'),
        );
      }
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));

        case 401: //unauthorized
          final model = ErrorModel.fromJson(e.response!.data);
          final isBadCredentials = model.errorMessage.toLowerCase().contains(
            'bad credentials',
          );
          final friendlyMessage = isBadCredentials
              ? 'بيانات الدخول غير صحيحة. يرجى التأكد من البريد وكلمة المرور.'
              : model.errorMessage;
          throw UnauthorizedException(
            ErrorModel(status: 401, errorMessage: friendlyMessage),
          );

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data));

        case 409: //cofficient
          throw CofficientException(ErrorModel.fromJson(e.response!.data));

        case 500: // Internal server error
        case 502: // Bad gateway
        case 503: // Service unavailable
        case 504: // Gateway timeout
        default: // Any other error status code
          throw BadResponseException(ErrorModel.fromJson(e.response!.data));
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: e.toString(), status: 500),
      );

    case DioExceptionType.unknown:
      // Check if it's a network-related unknown error
      String errorMessage = e.toString();
      if (e.error is SocketException) {
        final socketError = e.error as SocketException;
        if (socketError.message.contains('Software caused connection abort') ||
            socketError.message.contains('Connection aborted')) {
          errorMessage =
              'تم قطع الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
        } else {
          errorMessage =
              'خطأ في الاتصال: ${socketError.message}. يرجى المحاولة مرة أخرى.';
        }
      } else if (e.message != null &&
          (e.message!.contains('Software caused connection abort') ||
              e.message!.contains('Connection aborted'))) {
        errorMessage =
            'تم قطع الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.';
      }

      throw UnknownException(
        ErrorModel(errorMessage: errorMessage, status: 500),
      );
  }
}
