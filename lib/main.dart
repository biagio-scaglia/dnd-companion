import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'presentation/home/home_shell.dart';
import 'presentation/splash/splash_view.dart';
import 'features/notes/data/notes_repository_impl.dart';
import 'features/notes/presentation/notes_controller.dart';
import 'features/settings/data/settings_repository_impl.dart';
import 'features/settings/presentation/settings_controller.dart';
import 'features/map/data/map_repository_impl.dart';
import 'features/map/presentation/controllers/map_editor_controller.dart';
import 'presentation/home/home_controller.dart';
import 'features/backup/presentation/backup_controller.dart';
import 'features/backup/data/services/backup_service.dart';
import 'features/backup/data/services/archive_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotesController(repository: NotesRepositoryImpl()),
        ),

        ChangeNotifierProvider(
          create: (_) => SettingsController(repository: SettingsRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (_) => BackupController(
            backupService: BackupService(
              repository: NotesRepositoryImpl(),
              archiveService: ArchiveService(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final repo = MapRepositoryImpl();
            final controller = MapEditorController(repo);
            // Non possiamo fare chiamate async dirette nel costruttore in modo pulito qui,
            // quindi carichiamo le mappe al primo bisogno o possiamo fare un repo.getMaps()
            return controller;
          },
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
    return Consumer<SettingsController>(
      builder: (context, settingsController, child) {
        return MaterialApp(
          title: 'Vellum',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(accentColor: settingsController.settings.accentColor),
          locale: Locale(settingsController.settings.locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashView(),
        );
      },
    );
  }
}
