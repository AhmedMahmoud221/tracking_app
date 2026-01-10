import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class ApiErrorHandler {
  static String handle(dynamic error, BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return loc.connectionTimeout;
        case DioExceptionType.sendTimeout:
          return loc.sendTimeout;
        case DioExceptionType.receiveTimeout:
          return loc.receiveTimeout;
        case DioExceptionType.badResponse:
          return _handleStatusCode(
            error.response?.statusCode,
            error.response?.data,
            context,
          );
        case DioExceptionType.cancel:
          return loc.processCancelled;
        case DioExceptionType.connectionError:
          return loc.noInternet;
        default:
          return loc.unexpectedError;
      }
    } else {
      return loc.genericError;
    }
  }

  static String _handleStatusCode(
    int? statusCode,
    dynamic data,
    BuildContext context,
  ) {
    final loc = AppLocalizations.of(context)!;

    // إذا كان السيرفر يرسل رسالة خطأ معينة في الـ Body
    if (data != null && data is Map && data.containsKey('message')) {
      return data['message'];
    }

    switch (statusCode) {
      case 400:
        return loc.badRequest;
      case 401:
        return loc.unauthorized;
      case 403:
        return loc.forbidden;
      case 404:
        return loc.notFound;
      case 500:
        return loc.internalServerError;
      default:
        return "${loc.unknownError} (Code: $statusCode)";
    }
  }
}
