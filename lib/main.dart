import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:live_tracking/core/providers/app_providers.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/core/theme/app_theme.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/language_cubit/languageCubit.dart';
import 'package:live_tracking/injection_container.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

final sl = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String savedLang = await SecureStorage.readLanguage() ?? 'ar';
  String? token = await SecureStorage.readToken();

  await init(savedLang: savedLang);

  if (token != null && token.isNotEmpty) {
    sl<SocketService>().init(token);
    // print("🚀 Socket initialized from main with token");
  }

  runApp(const LiveTrackingApp());
}

class LiveTrackingApp extends StatelessWidget {
  const LiveTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.providers,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                routerConfig: AppRouter.router,
                debugShowCheckedModeBanner: false,
                title: 'Live Tracking App',
                theme: AppThemes.light,
                darkTheme: AppThemes.dark,
                themeMode: state == ThemeState.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                builder: (context, child) {
                  return Directionality(
                    textDirection: locale.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
