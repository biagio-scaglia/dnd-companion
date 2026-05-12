// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vellum';

  @override
  String get welcome => 'Welcome back, Traveler';

  @override
  String get diceRoll => 'Dice Roll';

  @override
  String get diceRollSub => 'Roll dice for your tests';

  @override
  String get maps => 'Maps';

  @override
  String get mapsSub => 'Explore and edit your worlds';

  @override
  String get lastMap => 'LAST ACTIVE MAP';

  @override
  String get compendium => 'From Compendium';

  @override
  String get compendiumSub => 'Latest secrets discovered';

  @override
  String get generator => 'Quick Generator';

  @override
  String get generatorSub => 'Tools for the Dungeon Master';

  @override
  String get loot => 'RANDOM LOOT';

  @override
  String get generate => 'Generate';

  @override
  String get contents => 'Your Contents';

  @override
  String get contentsSub => 'Summary of your resources';

  @override
  String get notes => 'Notes';

  @override
  String get sessions => 'Sessions';

  @override
  String get characters => 'Characters';

  @override
  String get noContent => 'No content yet';

  @override
  String get addContent =>
      'Add notes, sessions or characters from the Notes tab';

  @override
  String get emptyLoot => 'Tap \"Generate\" for loot';

  @override
  String get emptyRoll => 'Tap a die to roll';

  @override
  String get language => 'Language';

  @override
  String get languageApp => 'App Language';

  @override
  String get information => 'Information';

  @override
  String get app => 'App';

  @override
  String get build => 'Build';

  @override
  String get data => 'Data';

  @override
  String get savedLocally => 'Saved locally';

  @override
  String get mode => 'Mode';

  @override
  String get offlineFirst => 'Offline-first';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get cookiePolicy => 'Cookie Policy';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get exportData => 'Export Data (.comp)';

  @override
  String get restoreData => 'Restore Data (.comp)';

  @override
  String get permissions => 'Permissions';

  @override
  String get managePermissions => 'Manage App Permissions';

  @override
  String get privacyPolicyContent =>
      'This application respects your privacy. All entered data (notes, maps, characters) are saved exclusively locally on your device and are not sent to any external server.\\n\\nThe app does not collect personal data, does not require registration, and does not track your activities.\\n\\nThe requested permissions (such as memory access) only serve to allow you to save maps as images or attach files to your notes.';

  @override
  String get cookiePolicyContent =>
      'This application is developed in Flutter and is mainly intended as a mobile app.\\n\\nIt does not use tracking cookies, third-party cookies, or profiling cookies.\\n\\nIf used on a Web platform, only strictly necessary technical cookies might be used for the operation of the interface (such as maintaining state or local preferences via LocalStorage), which do not profile the user in any way.';

  @override
  String get createdForAdventurers => 'Created for true adventurers ⚔️';
}
