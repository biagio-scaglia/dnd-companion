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

  /// No description provided for @compendiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Compendium'**
  String get compendiumTitle;

  /// No description provided for @compendiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for knowledge and ancient secrets'**
  String get compendiumSubtitle;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @loadingCompendium.
  ///
  /// In en, this message translates to:
  /// **'Loading compendium...'**
  String get loadingCompendium;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @monsters.
  ///
  /// In en, this message translates to:
  /// **'Monsters'**
  String get monsters;

  /// No description provided for @spells.
  ///
  /// In en, this message translates to:
  /// **'Spells'**
  String get spells;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found...'**
  String get noResults;

  /// No description provided for @compendiumEmpty.
  ///
  /// In en, this message translates to:
  /// **'The compendium is empty.'**
  String get compendiumEmpty;

  /// No description provided for @tryOtherWords.
  ///
  /// In en, this message translates to:
  /// **'Try searching with other magic words.'**
  String get tryOtherWords;

  /// No description provided for @addElementsGrimoire.
  ///
  /// In en, this message translates to:
  /// **'Add items to populate this grimoire.'**
  String get addElementsGrimoire;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @monster.
  ///
  /// In en, this message translates to:
  /// **'Monster'**
  String get monster;

  /// No description provided for @spell.
  ///
  /// In en, this message translates to:
  /// **'Spell'**
  String get spell;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// No description provided for @fullDescription.
  ///
  /// In en, this message translates to:
  /// **'Full Description'**
  String get fullDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @detailsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Details not available'**
  String get detailsNotAvailable;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @appuntiESessioni.
  ///
  /// In en, this message translates to:
  /// **'Notes & Sessions'**
  String get appuntiESessioni;

  /// No description provided for @ritualFailed.
  ///
  /// In en, this message translates to:
  /// **'The summoning ritual failed'**
  String get ritualFailed;

  /// No description provided for @dataRetrieveError.
  ///
  /// In en, this message translates to:
  /// **'We could not retrieve your data from the abyss.'**
  String get dataRetrieveError;

  /// No description provided for @retryRitual.
  ///
  /// In en, this message translates to:
  /// **'Retry the ritual'**
  String get retryRitual;

  /// No description provided for @yourCharacters.
  ///
  /// In en, this message translates to:
  /// **'Your Characters'**
  String get yourCharacters;

  /// No description provided for @noHero.
  ///
  /// In en, this message translates to:
  /// **'No hero'**
  String get noHero;

  /// No description provided for @emptyCharacters.
  ///
  /// In en, this message translates to:
  /// **'The character list is empty.'**
  String get emptyCharacters;

  /// No description provided for @generateHero.
  ///
  /// In en, this message translates to:
  /// **'Generate Hero'**
  String get generateHero;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @noChapter.
  ///
  /// In en, this message translates to:
  /// **'No chapter'**
  String get noChapter;

  /// No description provided for @emptySessions.
  ///
  /// In en, this message translates to:
  /// **'The chronicle pages are empty.'**
  String get emptySessions;

  /// No description provided for @writeChapter.
  ///
  /// In en, this message translates to:
  /// **'Write Chapter'**
  String get writeChapter;

  /// No description provided for @recentNotes.
  ///
  /// In en, this message translates to:
  /// **'Recent Notes'**
  String get recentNotes;

  /// No description provided for @noMemory.
  ///
  /// In en, this message translates to:
  /// **'No memory'**
  String get noMemory;

  /// No description provided for @emptyNotes.
  ///
  /// In en, this message translates to:
  /// **'The pages are still blank.'**
  String get emptyNotes;

  /// No description provided for @transcribe.
  ///
  /// In en, this message translates to:
  /// **'Transcribe'**
  String get transcribe;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @noArtifact.
  ///
  /// In en, this message translates to:
  /// **'No artifact'**
  String get noArtifact;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get newNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get enterTitle;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @enterContent.
  ///
  /// In en, this message translates to:
  /// **'Enter content'**
  String get enterContent;

  /// No description provided for @tagsComma.
  ///
  /// In en, this message translates to:
  /// **'Tags (separated by comma)'**
  String get tagsComma;

  /// No description provided for @markAsImportant.
  ///
  /// In en, this message translates to:
  /// **'Mark as important'**
  String get markAsImportant;

  /// No description provided for @linkToSession.
  ///
  /// In en, this message translates to:
  /// **'Link to a session'**
  String get linkToSession;

  /// No description provided for @noSession.
  ///
  /// In en, this message translates to:
  /// **'No session'**
  String get noSession;

  /// No description provided for @attachmentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Attachment deleted'**
  String get attachmentDeleted;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete Note'**
  String get deleteNote;

  /// No description provided for @editSession.
  ///
  /// In en, this message translates to:
  /// **'Edit Session'**
  String get editSession;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @essentialData.
  ///
  /// In en, this message translates to:
  /// **'Essential Data'**
  String get essentialData;

  /// No description provided for @sessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Title *'**
  String get sessionTitle;

  /// No description provided for @sessionNumber.
  ///
  /// In en, this message translates to:
  /// **'Session Number'**
  String get sessionNumber;

  /// No description provided for @realDate.
  ///
  /// In en, this message translates to:
  /// **'Real Date *'**
  String get realDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @shortRecap.
  ///
  /// In en, this message translates to:
  /// **'Short Recap *'**
  String get shortRecap;

  /// No description provided for @enterShortRecap.
  ///
  /// In en, this message translates to:
  /// **'Enter a short recap'**
  String get enterShortRecap;

  /// No description provided for @campaignDetails.
  ///
  /// In en, this message translates to:
  /// **'Campaign Details'**
  String get campaignDetails;

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign;

  /// No description provided for @inGameDate.
  ///
  /// In en, this message translates to:
  /// **'In-Game Date'**
  String get inGameDate;

  /// No description provided for @inGameLocation.
  ///
  /// In en, this message translates to:
  /// **'In-Game Location'**
  String get inGameLocation;

  /// No description provided for @listsAndContents.
  ///
  /// In en, this message translates to:
  /// **'Lists and Contents'**
  String get listsAndContents;

  /// No description provided for @mainEvents.
  ///
  /// In en, this message translates to:
  /// **'Main Events'**
  String get mainEvents;

  /// No description provided for @metNpcs.
  ///
  /// In en, this message translates to:
  /// **'Met NPCs'**
  String get metNpcs;

  /// No description provided for @visitedLocations.
  ///
  /// In en, this message translates to:
  /// **'Visited Locations'**
  String get visitedLocations;

  /// No description provided for @completedObjectives.
  ///
  /// In en, this message translates to:
  /// **'Completed Objectives'**
  String get completedObjectives;

  /// No description provided for @openObjectives.
  ///
  /// In en, this message translates to:
  /// **'Open Objectives'**
  String get openObjectives;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @notesAndLoot.
  ///
  /// In en, this message translates to:
  /// **'Notes & Loot'**
  String get notesAndLoot;

  /// No description provided for @lootRewards.
  ///
  /// In en, this message translates to:
  /// **'Loot / Rewards'**
  String get lootRewards;

  /// No description provided for @freeNotes.
  ///
  /// In en, this message translates to:
  /// **'Free Notes'**
  String get freeNotes;

  /// No description provided for @editCharacter.
  ///
  /// In en, this message translates to:
  /// **'Edit Character'**
  String get editCharacter;

  /// No description provided for @newCharacter.
  ///
  /// In en, this message translates to:
  /// **'New Character'**
  String get newCharacter;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @characterName.
  ///
  /// In en, this message translates to:
  /// **'Character Name *'**
  String get characterName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// No description provided for @raceSpecies.
  ///
  /// In en, this message translates to:
  /// **'Race / Species *'**
  String get raceSpecies;

  /// No description provided for @enterRace.
  ///
  /// In en, this message translates to:
  /// **'Enter race'**
  String get enterRace;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class *'**
  String get classLabel;

  /// No description provided for @enterClass.
  ///
  /// In en, this message translates to:
  /// **'Enter class'**
  String get enterClass;

  /// No description provided for @subclassLabel.
  ///
  /// In en, this message translates to:
  /// **'Subclass'**
  String get subclassLabel;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level *'**
  String get levelLabel;

  /// No description provided for @enterLevel.
  ///
  /// In en, this message translates to:
  /// **'Enter level'**
  String get enterLevel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status *'**
  String get statusLabel;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @dead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get dead;

  /// No description provided for @retired.
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get retired;

  /// No description provided for @npcAlly.
  ///
  /// In en, this message translates to:
  /// **'NPC Ally'**
  String get npcAlly;

  /// No description provided for @campaignRoleData.
  ///
  /// In en, this message translates to:
  /// **'Campaign & Role Data'**
  String get campaignRoleData;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get playerName;

  /// No description provided for @alignment.
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get alignment;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @traitsNarrative.
  ///
  /// In en, this message translates to:
  /// **'Traits & Narrative Background'**
  String get traitsNarrative;

  /// No description provided for @personalityTraits.
  ///
  /// In en, this message translates to:
  /// **'Personality Traits'**
  String get personalityTraits;

  /// No description provided for @ideals.
  ///
  /// In en, this message translates to:
  /// **'Ideals'**
  String get ideals;

  /// No description provided for @bonds.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get bonds;

  /// No description provided for @flaws.
  ///
  /// In en, this message translates to:
  /// **'Flaws'**
  String get flaws;

  /// No description provided for @descriptionNotes.
  ///
  /// In en, this message translates to:
  /// **'Description & Notes'**
  String get descriptionNotes;

  /// No description provided for @deleteAttachmentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this attachment?'**
  String get deleteAttachmentConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @levelShort.
  ///
  /// In en, this message translates to:
  /// **'Lvl.'**
  String get levelShort;

  /// No description provided for @ally.
  ///
  /// In en, this message translates to:
  /// **'Ally'**
  String get ally;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @chronicles.
  ///
  /// In en, this message translates to:
  /// **'Chronicles'**
  String get chronicles;

  /// No description provided for @lore.
  ///
  /// In en, this message translates to:
  /// **'Lore'**
  String get lore;

  /// No description provided for @memories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get memories;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @cartography.
  ///
  /// In en, this message translates to:
  /// **'Cartography'**
  String get cartography;

  /// No description provided for @backupDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup downloaded successfully!'**
  String get backupDownloadSuccess;

  /// No description provided for @backupCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully!'**
  String get backupCreateSuccess;

  /// No description provided for @backupExportError.
  ///
  /// In en, this message translates to:
  /// **'Error during export'**
  String get backupExportError;

  /// No description provided for @invalidBackupFile.
  ///
  /// In en, this message translates to:
  /// **'The selected file is not a valid .comp backup.'**
  String get invalidBackupFile;

  /// No description provided for @cannotReadManifest.
  ///
  /// In en, this message translates to:
  /// **'Cannot read backup manifest.'**
  String get cannotReadManifest;

  /// No description provided for @backupReadError.
  ///
  /// In en, this message translates to:
  /// **'Error reading file'**
  String get backupReadError;

  /// No description provided for @backupImportError.
  ///
  /// In en, this message translates to:
  /// **'Error during import'**
  String get backupImportError;

  /// No description provided for @backupOverwritten.
  ///
  /// In en, this message translates to:
  /// **'Data overwritten successfully!'**
  String get backupOverwritten;

  /// No description provided for @backupMerged.
  ///
  /// In en, this message translates to:
  /// **'Data merged successfully!'**
  String get backupMerged;

  /// No description provided for @backupUnsupportedVersion.
  ///
  /// In en, this message translates to:
  /// **'Unsupported format version. Please update the app.'**
  String get backupUnsupportedVersion;

  /// No description provided for @ignored.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get ignored;

  /// No description provided for @duplicated.
  ///
  /// In en, this message translates to:
  /// **'Duplicated'**
  String get duplicated;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restoration Ritual'**
  String get restoreTitle;

  /// No description provided for @foundInFile.
  ///
  /// In en, this message translates to:
  /// **'Found in file:'**
  String get foundInFile;

  /// No description provided for @chooseProceed.
  ///
  /// In en, this message translates to:
  /// **'Choose how to proceed:'**
  String get chooseProceed;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning!'**
  String get warning;

  /// No description provided for @overwriteWarning.
  ///
  /// In en, this message translates to:
  /// **'This operation will DELETE all current app data and replace it with the backup. Are you sure?'**
  String get overwriteWarning;

  /// No description provided for @yesOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Yes, Overwrite'**
  String get yesOverwrite;

  /// No description provided for @recentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent Sessions'**
  String get recentSessions;

  /// No description provided for @recapWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'Recap what happened'**
  String get recapWhatHappened;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded.'**
  String get noSessions;

  /// No description provided for @nothingLost.
  ///
  /// In en, this message translates to:
  /// **'Nothing is lost between sessions'**
  String get nothingLost;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newTag;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @detailsNotAvailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Details not available offline for this item.'**
  String get detailsNotAvailableOffline;

  /// No description provided for @newMap.
  ///
  /// In en, this message translates to:
  /// **'New Map'**
  String get newMap;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied!'**
  String get storagePermissionDenied;

  /// No description provided for @webSaveNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Saving on Web not implemented directly. Use screenshot!'**
  String get webSaveNotImplemented;

  /// No description provided for @mapSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Map saved to gallery!'**
  String get mapSavedToGallery;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving!'**
  String get saveError;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// No description provided for @renameMap.
  ///
  /// In en, this message translates to:
  /// **'Rename Map'**
  String get renameMap;

  /// No description provided for @mapNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Map Name'**
  String get mapNameLabel;

  /// No description provided for @mapEditor.
  ///
  /// In en, this message translates to:
  /// **'Map Editor'**
  String get mapEditor;

  /// No description provided for @hideUI.
  ///
  /// In en, this message translates to:
  /// **'Hide UI'**
  String get hideUI;

  /// No description provided for @showUI.
  ///
  /// In en, this message translates to:
  /// **'Show UI'**
  String get showUI;

  /// No description provided for @exportAsImage.
  ///
  /// In en, this message translates to:
  /// **'Export as image'**
  String get exportAsImage;

  /// No description provided for @mapSaved.
  ///
  /// In en, this message translates to:
  /// **'Map saved!'**
  String get mapSaved;

  /// No description provided for @loadingEditor.
  ///
  /// In en, this message translates to:
  /// **'Loading editor...'**
  String get loadingEditor;

  /// No description provided for @noMapOpen.
  ///
  /// In en, this message translates to:
  /// **'No map open'**
  String get noMapOpen;

  /// No description provided for @tapPlusToCreate.
  ///
  /// In en, this message translates to:
  /// **'Tap the + at the top or the button below to create one.'**
  String get tapPlusToCreate;

  /// No description provided for @createNewMap.
  ///
  /// In en, this message translates to:
  /// **'Create New Map'**
  String get createNewMap;

  /// No description provided for @cannotDeleteLastLayer.
  ///
  /// In en, this message translates to:
  /// **'You cannot delete the last layer!'**
  String get cannotDeleteLastLayer;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @brush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get brush;

  /// No description provided for @eraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get eraser;

  /// No description provided for @showTools.
  ///
  /// In en, this message translates to:
  /// **'Show Tools'**
  String get showTools;

  /// No description provided for @layers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layers;

  /// No description provided for @renameLayer.
  ///
  /// In en, this message translates to:
  /// **'Rename Layer'**
  String get renameLayer;

  /// No description provided for @layerName.
  ///
  /// In en, this message translates to:
  /// **'Layer Name'**
  String get layerName;

  /// No description provided for @addLayer.
  ///
  /// In en, this message translates to:
  /// **'Add Layer'**
  String get addLayer;

  /// No description provided for @layerNameExample.
  ///
  /// In en, this message translates to:
  /// **'Layer name (e.g. Traps)'**
  String get layerNameExample;

  /// No description provided for @deleteLayer.
  ///
  /// In en, this message translates to:
  /// **'Delete Layer'**
  String get deleteLayer;

  /// No description provided for @deleteLayerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the layer \"{layerName}\"? This action cannot be undone.'**
  String deleteLayerConfirm(String layerName);

  /// No description provided for @tile.
  ///
  /// In en, this message translates to:
  /// **'Tile'**
  String get tile;

  /// No description provided for @selectTile.
  ///
  /// In en, this message translates to:
  /// **'Select Tile'**
  String get selectTile;

  /// No description provided for @iconsAndEmoji.
  ///
  /// In en, this message translates to:
  /// **'Icons & Emoji'**
  String get iconsAndEmoji;

  /// No description provided for @browseIcons.
  ///
  /// In en, this message translates to:
  /// **'Browse Icons'**
  String get browseIcons;

  /// No description provided for @equip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get equip;

  /// No description provided for @potions.
  ///
  /// In en, this message translates to:
  /// **'Potions'**
  String get potions;

  /// No description provided for @weapons.
  ///
  /// In en, this message translates to:
  /// **'Weapons'**
  String get weapons;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @gems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get gems;

  /// No description provided for @misc.
  ///
  /// In en, this message translates to:
  /// **'Misc'**
  String get misc;

  /// No description provided for @emoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get emoji;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get addAttachment;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments for this section'**
  String get noAttachments;

  /// No description provided for @tapToRoll.
  ///
  /// In en, this message translates to:
  /// **'Tap a die to roll'**
  String get tapToRoll;

  /// No description provided for @noMap.
  ///
  /// In en, this message translates to:
  /// **'No map'**
  String get noMap;

  /// No description provided for @monsterOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Monster of the Day'**
  String get monsterOfTheDay;

  /// No description provided for @goldCoins.
  ///
  /// In en, this message translates to:
  /// **'10 Gold Coins'**
  String get goldCoins;

  /// No description provided for @healingPotion.
  ///
  /// In en, this message translates to:
  /// **'Healing Potion'**
  String get healingPotion;

  /// No description provided for @gem50.
  ///
  /// In en, this message translates to:
  /// **'Precious Gem (50 gp)'**
  String get gem50;

  /// No description provided for @swordPlus1.
  ///
  /// In en, this message translates to:
  /// **'Shortsword +1'**
  String get swordPlus1;

  /// No description provided for @silverRing.
  ///
  /// In en, this message translates to:
  /// **'Ancient Silver Ring'**
  String get silverRing;

  /// No description provided for @treasureMap.
  ///
  /// In en, this message translates to:
  /// **'Crumpled Treasure Map'**
  String get treasureMap;

  /// No description provided for @magicMissileScroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll of \'Magic Missile\''**
  String get magicMissileScroll;

  /// No description provided for @rustyKey.
  ///
  /// In en, this message translates to:
  /// **'Rusty Iron Key'**
  String get rustyKey;

  /// No description provided for @aberration.
  ///
  /// In en, this message translates to:
  /// **'Aberration'**
  String get aberration;

  /// No description provided for @beholderDesc.
  ///
  /// In en, this message translates to:
  /// **'A large floating eye with many smaller eyes on stalks. It is one of the most iconic monsters in D&D.'**
  String get beholderDesc;

  /// No description provided for @resultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result: {value}'**
  String resultLabel(String value);

  /// No description provided for @chooseDice.
  ///
  /// In en, this message translates to:
  /// **'Choose a die to roll'**
  String get chooseDice;

  /// No description provided for @lastRolls.
  ///
  /// In en, this message translates to:
  /// **'Last rolls:'**
  String get lastRolls;
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
