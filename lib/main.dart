import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/home_shell.dart';
import 'features/notes/data/notes_repository_impl.dart';
import 'features/notes/data/calendar_repository_impl.dart';
import 'features/notes/presentation/notes_controller.dart';
import 'features/notes/presentation/calendar_controller.dart';
import 'features/settings/data/settings_repository_impl.dart';
import 'features/settings/presentation/settings_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesController(repository: NotesRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarController(repository: CalendarRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsController(repository: SettingsRepositoryImpl()),
        ),
      ],
      child: const DndCompanionApp(),
    ),
  );
}

class DndCompanionApp extends StatelessWidget {
  const DndCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeShell(),
    );
  }
}
