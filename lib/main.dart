import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:dnd/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
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
  // BUG FIX 1: Necessario prima di qualsiasi utilizzo di plugin nativi
  // (SharedPreferences, sqflite, path_provider, permission_handler, etc.)
  WidgetsFlutterBinding.ensureInitialized();

  // BUG FIX 2: Global Flutter error handler — cattura errori nei widget builder
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('⚠️ [FlutterError] ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
    // Non crashiamo: loghiamo e andiamo avanti
  };

  // BUG FIX 2: Cattura errori async non gestiti nella piattaforma
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('⚠️ [PlatformDispatcher] $error');
    debugPrint(stack.toString());
    return true; // Segnala che abbiamo gestito l'errore
  };

  final notesRepository = NotesRepositoryImpl();

  // BUG FIX 2: runZonedGuarded cattura tutti gli altri errori async non gestiti
  runZonedGuarded(
    () {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => HomeController(),
            ),
            ChangeNotifierProvider(
              create: (_) => NotesController(repository: notesRepository),
            ),
            ChangeNotifierProvider(
              create: (_) =>
                  SettingsController(repository: SettingsRepositoryImpl()),
            ),
            ChangeNotifierProvider(
              create: (_) => BackupController(
                backupService: BackupService(
                  repository: notesRepository,
                  archiveService: ArchiveService(),
                ),
              ),
            ),
            ChangeNotifierProvider(
              create: (_) {
                final repo = MapRepositoryImpl();
                final controller = MapEditorController(repo);
                return controller;
              },
            ),
          ],
          child: const DndCompanionApp(),
        ),
      );
    },
    (Object error, StackTrace stack) {
      debugPrint('🔴 [ZonedGuarded] Uncaught error: $error');
      debugPrint(stack.toString());
      // Non terminiamo l'app — l'utente vedrà l'errore solo se impedisce la UI
    },
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
          theme: AppTheme.getTheme(
              accentColor: settingsController.settings.accentColor),
          locale: Locale(settingsController.settings.locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
            }
            return const Locale('en');
          },
          home: const SplashView(),
          // Failsafe builder: impedisce schermata bianca se un widget crasha
          builder: (context, child) {
            return child ?? const _AppFallbackWidget();
          },
        );
      },
    );
  }
}

/// Widget di fallback sicuro mostrato se il widget tree non è disponibile.
class _AppFallbackWidget extends StatelessWidget {
  const _AppFallbackWidget();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white54, size: 48),
            SizedBox(height: 16),
            Text(
              'VELLUM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Riavvia l\'app per continuare',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
