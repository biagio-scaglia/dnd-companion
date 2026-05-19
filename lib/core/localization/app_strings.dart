class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    'it': {
      'app_title': 'VELLUM',
      'welcome': 'Bentornato, Viaggiatore',
      'dice_roll': 'Lancio Dadi',
      'dice_roll_sub': 'Tira i dadi per le tue prove',
      'maps': 'Mappe',
      'maps_sub': 'Esplora e modifica i tuoi mondi',
      'last_map': 'ULTIMA MAPPA ATTIVA',
      'compendium': 'Dal Compendio',
      'compendium_sub': 'Ultimi segreti scoperti',
      'generator': 'Generatore Rapido',
      'generator_sub': 'Strumenti per il Dungeon Master',
      'loot': 'BOTTINO CASUALE',
      'generate': 'Genera',
      'contents': 'I Tuoi Contenuti',
      'contents_sub': 'Riepilogo delle tue risorse',
      'notes': 'Note',
      'sessions': 'Sessioni',
      'characters': 'Personaggi',
      'no_content': 'Nessun contenuto ancora',
      'add_content': 'Aggiungi note, sessioni o personaggi dalla tab Appunti',
      'empty_loot': 'Tocca "Genera" per un bottino',
      'empty_roll': "Tocca un dado per l'lancio",
    },
    'en': {
      'app_title': 'VELLUM',
      'welcome': 'Welcome back, Traveler',
      'dice_roll': 'Dice Roll',
      'dice_roll_sub': 'Roll dice for your tests',
      'maps': 'Maps',
      'maps_sub': 'Explore and edit your worlds',
      'last_map': 'LAST ACTIVE MAP',
      'compendium': 'From Compendium',
      'compendium_sub': 'Latest secrets discovered',
      'generator': 'Quick Generator',
      'generator_sub': 'Tools for the Dungeon Master',
      'loot': 'RANDOM LOOT',
      'generate': 'Generate',
      'contents': 'Your Contents',
      'contents_sub': 'Summary of your resources',
      'notes': 'Notes',
      'sessions': 'Sessions',
      'characters': 'Characters',
      'no_content': 'No content yet',
      'add_content': 'Add notes, sessions or characters from the Notes tab',
      'empty_loot': 'Tap "Generate" for loot',
      'empty_roll': 'Tap a die to roll',
    }
  };

  static String get(String key, String lang) {
    return _strings[lang]?[key] ?? _strings['en']?[key] ?? key;
  }
}
