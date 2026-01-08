import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "انتهت مهلة الاتصال، تأكد من الإنترنت.";
        case DioExceptionType.sendTimeout:
          return "فشل إرسال البيانات، حاول مرة أخرى.";
        case DioExceptionType.receiveTimeout:
          return "الخادم لم يستجب في الوقت المحدد.";
        case DioExceptionType.badResponse:
          return _handleStatusCode(error.response?.statusCode, error.response?.data);
        case DioExceptionType.cancel:
          return "تم إلغاء العملية.";
        case DioExceptionType.connectionError:
          return "لا يوجد اتصال بالإنترنت.";
        default:
          return "عذراً، حدث خطأ غير متوقع.";
      }
    } else {
      return "حدث خطأ ما، يرجى المحاولة لاحقاً.";
    }
  }

  static String _handleStatusCode(int? statusCode, dynamic data) {
    // إذا كان السيرفر يرسل رسالة خطأ معينة في الـ Body
    if (data != null && data is Map && data.containsKey('message')) {
      return data['message'];
    }

    switch (statusCode) {
      case 400:
        return "بيانات غير صالحة.";
      case 401:
        return "غير مصرح لك بالدخول.";
      case 403:
        return "ليس لديك صلاحية الوصول.";
      case 404:
        return "الصفحة أو المستخدم غير موجود.";
      case 500:
        return "مشكلة في السيرفر الداخلي، جاري العمل على حلها.";
      default:
        return "حدث خطأ غير معروف (كود: $statusCode).";
    }
  }
}