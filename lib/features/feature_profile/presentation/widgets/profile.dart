import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/app_router.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/language_cubit/languageCubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_state.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_logout.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_profile_header.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_profile_item.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_toggle.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:live_tracking/main.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static const id = '/profile';

  @override
  Widget build(BuildContext context) {
    // استخدمنا MultiBlocProvider عشان نجمع كل الـ Cubits في مكان واحد فوق الـ Scaffold
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProfileDataCubit>()..fetchProfile(),
        ),
        BlocProvider(
          create: (_) => LogOutCubit(LogoutUseCase(AuthService())),
        ),
      ],
      child: Scaffold(
        // استخدمنا BlocConsumer في الجسم الأساسي للشاشة
        body: BlocConsumer<ProfileDataCubit, ProfileDataState>(
          listener: (context, state) {
            if (state is ProfileDataLoaded) {
              debugPrint("✅ UI Updated with name: ${state.profile.name}");
            }
          },
          builder: (context, state) {
            if (state is ProfileDataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileDataLoaded) {
              return RefreshIndicator(
                color: Colors.blue,
                onRefresh: () async => context.read<ProfileDataCubit>().fetchProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      CustomProfileHeader(profile: state.profile),
                      
                      const SizedBox(height: 10),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomToggle(),
                      ),
                  
                      CustomProfileitems(
                        title: AppLocalizations.of(context)!.notification,
                        icon: Icons.notifications,
                        onTap: () {},
                      ),
                      
                      CustomProfileitems(
                        title: AppLocalizations.of(context)!.language,
                        icon: Icons.language,
                        onTap: () {
                          _showLanguageBottomSheet(context);
                        },
                      ),
                      
                      CustomProfileitems(
                        title: AppLocalizations.of(context)!.changePassword,
                        icon: Icons.lock,
                        onTap: () {
                          context.push(AppRouter.kChangePassword);
                        },
                      ),
                  
                      // جزء الـ Logout مع الـ Listener الخاص به
                      BlocListener<LogOutCubit, LogOutState>(
                        listener: (context, state) {
                          if (state is LogoutSuccessState) {
                            context.go('/login');
                          } else if (state is LogoutErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                        child: BlocBuilder<LogOutCubit, LogOutState>(
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: LogoutButton(
                                isLoading: state is LogoutLoadingState,
                                onTap: () {
                                  context.read<LogOutCubit>().logout();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileDataError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ميثود جانبية لتنظيم الكود الخاص بتغيير اللغة
  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            onTap: () {
              context.read<LanguageCubit>().changeLanguage(const Locale('en'));
              Navigator.pop(bottomSheetContext);
            },
          ),
          ListTile(
            title: const Text('عربي'),
            onTap: () {
              context.read<LanguageCubit>().changeLanguage(const Locale('ar'));
              Navigator.pop(bottomSheetContext);
            },
          ),
        ],
      ),
    );
  }
}