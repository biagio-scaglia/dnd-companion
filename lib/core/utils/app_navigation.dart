import 'package:flutter/foundation.dart';
import '../../features/compendium/domain/models/compendium_item.dart';

class AppNavigation {
  static final AppNavigation instance = AppNavigation._();
  AppNavigation._();

  final ValueNotifier<int> currentTab = ValueNotifier<int>(0);
  final ValueNotifier<CompendiumItemType?> initialFilter = ValueNotifier(null);

  void goToCompendium({CompendiumItemType? filter}) {
    if (filter != null) {
      initialFilter.value = filter;
    }
    currentTab.value = 1; // 1 is the Compendium index in the shell
  }

  void goToNotes() {
    currentTab.value = 2; // 2 is the Notes index in the shell
  }
}
