// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Vellum';

  @override
  String get welcome => 'Bentornato, Viaggiatore';

  @override
  String get diceRoll => 'Lancio Dadi';

  @override
  String get diceRollSub => 'Tira i dadi per le tue prove';

  @override
  String get maps => 'Mappe';

  @override
  String get mapsSub => 'Esplora e modifica i tuoi mondi';

  @override
  String get lastMap => 'ULTIMA MAPPA ATTIVA';

  @override
  String get compendium => 'Dal Compendio';

  @override
  String get compendiumSub => 'Ultimi segreti scoperti';

  @override
  String get generator => 'Generatore Rapido';

  @override
  String get generatorSub => 'Strumenti per il Dungeon Master';

  @override
  String get loot => 'BOTTINO CASUALE';

  @override
  String get generate => 'Genera';

  @override
  String get contents => 'I Tuoi Contenuti';

  @override
  String get contentsSub => 'Riepilogo delle tue risorse';

  @override
  String get notes => 'Note';

  @override
  String get sessions => 'Sessioni';

  @override
  String get characters => 'Personaggi';

  @override
  String get noContent => 'Nessun contenuto ancora';

  @override
  String get addContent =>
      'Aggiungi note, sessioni o personaggi dalla tab Appunti';

  @override
  String get emptyLoot => 'Tocca \"Genera\" per un bottino';

  @override
  String get emptyRoll => 'Tocca un dado per l\'lancio';

  @override
  String get language => 'Lingua';

  @override
  String get languageApp => 'Lingua App';

  @override
  String get information => 'Informazioni';

  @override
  String get app => 'App';

  @override
  String get build => 'Build';

  @override
  String get data => 'Dati';

  @override
  String get savedLocally => 'Salvati localmente';

  @override
  String get mode => 'Modalità';

  @override
  String get offlineFirst => 'Offline-first';

  @override
  String get legal => 'Legale';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get cookiePolicy => 'Cookie Policy';

  @override
  String get backupRestore => 'Backup e Ripristino';

  @override
  String get exportData => 'Esporta Dati (.comp)';

  @override
  String get restoreData => 'Ripristina Dati (.comp)';

  @override
  String get permissions => 'Permessi';

  @override
  String get managePermissions => 'Gestisci Permessi App';

  @override
  String get privacyPolicyContent =>
      'Questa applicazione rispetta la tua privacy. Tutti i dati inseriti (note, mappe, personaggi) vengono salvati esclusivamente in locale sul tuo dispositivo e non vengono inviati a nessun server esterno.\\n\\nL\'app non raccoglie dati personali, non richiede registrazione e non traccia le tue attività.\\n\\nI permessi richiesti (come l\'accesso alla memoria) servono solo per consentirti di salvare le mappe come immagini o allegare file alle tue note.';

  @override
  String get cookiePolicyContent =>
      'Questa applicazione è sviluppata in Flutter ed è pensata principalmente come app mobile.\\n\\nNon utilizza cookie di tracciamento, cookie di terze parti o cookie di profilazione.\\n\\nSe utilizzata su piattaforma Web, potrebbero essere utilizzati solo cookie tecnici strettamente necessari per il funzionamento dell\'interfaccia (come il mantenimento dello stato o delle preferenze locali tramite LocalStorage), che non profilano l\'utente in alcun modo.';

  @override
  String get createdForAdventurers => 'Creato per veri avventurieri ⚔️';
}
