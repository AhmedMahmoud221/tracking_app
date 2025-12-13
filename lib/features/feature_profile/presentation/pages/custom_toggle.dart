import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';

class CustomToggle extends StatelessWidget {
  const CustomToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final bool isDark = state == ThemeState.dark;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF7B7B7B),
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme(value);
              },
              activeColor: isDark
                  ? Colors.black
                  : Colors.red, // الديرة المتحركة
              activeTrackColor: isDark
                  ? Colors.grey
                  : Colors.red.shade100, // الخلفية
            ),
          ],
        );
      },
    );
  }
}
