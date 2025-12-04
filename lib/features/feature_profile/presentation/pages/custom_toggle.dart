import 'package:flutter/material.dart';
import 'package:live_tracking/core/constants/theme_provider.dart';

class CustomToggle extends StatelessWidget {
  const CustomToggle({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dark Mode',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white     // dark mode ( white color )
                  : const Color(0xFF7B7B7B), // light mode ( dark grey color )
            ),
        ),
        Switch(
          value: theme.brightness == Brightness.dark,
          
          // theme colors
          activeThumbColor: Colors.lightBlueAccent,  //circle color when Dark Mode is on
          activeTrackColor: Colors.blueGrey,  // background color when Dark Mode is on
    
          inactiveThumbColor: Colors.grey[700],   // circle color in Light Mode
          inactiveTrackColor: Colors.grey[300],    // background color in Light Mode
          
          splashRadius: 0, // Remove splash effect

          onChanged: (value) {
            ThemeProvider.toggleTheme(); 
          },
        ),
      ],
    );
  }
}