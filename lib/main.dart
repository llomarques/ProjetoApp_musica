
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VibeOnApp());
}

class VibeOnApp extends StatelessWidget {
  const VibeOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VibeOn',
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
