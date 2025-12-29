import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(super.initialLocale);

  void changeLanguage(Locale locale) async {
    await SecureStorage.writeLanguage(locale.languageCode);

    emit(locale);
  }
}
