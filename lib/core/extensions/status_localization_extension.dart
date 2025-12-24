import 'package:flutter/material.dart';

extension StatusLocalization on String {
  String localized(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    switch (toLowerCase()) {
      case 'moving':
        return lang == 'ar' ? 'متحرك' : 'Moving';
      case 'parking':
        return lang == 'ar' ? 'متوقف' : 'Parking';
      case 'idling':
        return lang == 'ar' ? 'خامل' : 'Idling';
      case 'towed':
        return lang == 'ar' ? 'مسحوب' : 'Towed';
      default:
        return this;
    }
  }
}
