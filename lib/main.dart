import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/home_shell.dart';
import 'presentation/home/home_view.dart';

void main() {
  runApp(const DndCompanionApp());
}

class DndCompanionApp extends StatelessWidget {
  const DndCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeShell(
        // Passiamo la HomeView come primo figlio della shell
        child: HomeView(),
      ),
    );
  }
}
