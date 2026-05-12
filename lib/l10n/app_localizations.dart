import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Vellum'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Traveler'**
  String get welcome;

  /// No description provided for @diceRoll.
  ///
  /// In en, this message translates to:
  /// **'Dice Roll'**
  String get diceRoll;

  /// No description provided for @diceRollSub.
  ///
  /// In en, this message translates to:
  /// **'Roll dice for your tests'**
  String get diceRollSub;

  /// No description provided for @maps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get maps;

  /// No description provided for @mapsSub.
  ///
  /// In en, this message translates to:
  /// **'Explore and edit your worlds'**
  String get mapsSub;

  /// No description provided for @lastMap.
  ///
  /// In en, this message translates to:
  /// **'LAST ACTIVE MAP'**
  String get lastMap;

  /// No description provided for @compendium.
  ///
  /// In en, this message translates to:
  /// **'From Compendium'**
  String get compendium;

  /// No description provided for @compendiumSub.
  ///
  /// In en, this message translates to:
  /// **'Latest secrets discovered'**
  String get compendiumSub;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'Quick Generator'**
  String get generator;

  /// No description provided for @generatorSub.
  ///
  /// In en, this message translates to:
  /// **'Tools for the Dungeon Master'**
  String get generatorSub;

  /// No description provided for @loot.
  ///
  /// In en, this message translates to:
  /// **'RANDOM LOOT'**
  String get loot;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @contents.
  ///
  /// In en, this message translates to:
  /// **'Your Contents'**
  String get contents;

  /// No description provided for @contentsSub.
  ///
  /// In en, this message translates to:
  /// **'Summary of your resources'**
  String get contentsSub;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characters;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noContent;

  /// No description provided for @addContent.
  ///
  /// In en, this message translates to:
  /// **'Add notes, sessions or characters from the Notes tab'**
  String get addContent;

  /// No description provided for @emptyLoot.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Generate\" for loot'**
  String get emptyLoot;

  /// No description provided for @emptyRoll.
  ///
  /// In en, this message translates to:
  /// **'Tap a die to roll'**
  String get emptyRoll;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageApp.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageApp;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @savedLocally.
  ///
  /// In en, this message translates to:
  /// **'Saved locally'**
  String get savedLocally;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @offlineFirst.
  ///
  /// In en, this message translates to:
  /// **'Offline-first'**
  String get offlineFirst;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @cookiePolicy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get cookiePolicy;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data (.comp)'**
  String get exportData;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore Data (.comp)'**
  String get restoreData;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @managePermissions.
  ///
  /// In en, this message translates to:
  /// **'Manage App Permissions'**
  String get managePermissions;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'This application respects your privacy. All entered data (notes, maps, characters) are saved exclusively locally on your device and are not sent to any external server.\\n\\nThe app does not collect personal data, does not require registration, and does not track your activities.\\n\\nThe requested permissions (such as memory access) only serve to allow you to save maps as images or attach files to your notes.'**
  String get privacyPolicyContent;

  /// No description provided for @cookiePolicyContent.
  ///
  /// In en, this message translates to:
  /// **'This application is developed in Flutter and is mainly intended as a mobile app.\\n\\nIt does not use tracking cookies, third-party cookies, or profiling cookies.\\n\\nIf used on a Web platform, only strictly necessary technical cookies might be used for the operation of the interface (such as maintaining state or local preferences via LocalStorage), which do not profile the user in any way.'**
  String get cookiePolicyContent;

  /// No description provided for @createdForAdventurers.
  ///
  /// In en, this message translates to:
  /// **'Created for true adventurers ⚔️'**
  String get createdForAdventurers;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
