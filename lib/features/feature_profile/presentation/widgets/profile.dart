import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'package:live_tracking/features/feature_profile/data/datasources/user_profile_api.dart';
import 'package:live_tracking/features/feature_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_cubit.dart';
import 'package:live_tracking/features/feature_profile/presentation/cubit/profile_data_cubit/cubit/profile_data_cubit_state.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_logout.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_profile_header.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_profile_item.dart';
import 'package:live_tracking/features/feature_profile/presentation/pages/custom_toggle.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static const id = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f7),
      body: MultiBlocProvider(
        providers: [
          // Cubit الخاص بالـ logout
          BlocProvider(
            create: (_) => ProfileCubit(LogoutUseCase(AuthService())),
          ),

          // Cubit الخاص ببيانات البروفايل
          BlocProvider(
            create: (_) => ProfileDataCubit(
              GetUserProfileUseCase(
                UserProfileRepositoryImpl(
                  UserProfileApi(
                    "https://r8c974qv-5000.uks1.devtunnels.ms", // <=== حط هنا الـ base URL الصح
                  ),
                ),
              ),
            )..fetchProfile(),
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<ProfileDataCubit, ProfileDataState>(
                builder: (context, state) {
                  if (state is ProfileDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProfileDataLoaded) {
                    return Column(
                      children: [
                        CustomProfileHeader(profile: state.profile),
                        const SizedBox(height: 10),
                      ],
                    );
                  } else if (state is ProfileDataError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomToggle(theme: Theme.of(context)),
              ),

              CustomProfileitems(
                title: "Notification",
                icon: Icons.notifications,
                onTap: () {},
              ),
              CustomProfileitems(
                title: "Language",
                icon: Icons.language,
                onTap: () {},
              ),
              CustomProfileitems(
                title: "Change Password",
                icon: Icons.lock,
                onTap: () {},
              ),

              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading = state is LogoutLoadingState;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LogoutButton(
                      isLoading: isLoading,
                      onTap: () {
                        context.read<ProfileCubit>().logout();
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
