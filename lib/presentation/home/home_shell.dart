import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../features/compendium/presentation/compendium_view.dart';
import '../../features/notes/presentation/notes_view.dart';
import '../../features/map/presentation/map_tab_view.dart';
import '../../features/settings/presentation/settings_view.dart';
import '../../core/utils/app_navigation.dart';
import '../../core/services/guide_service.dart';
import 'home_view.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    AppNavigation.instance.currentTab.addListener(_onTabChanged);
    AppNavigation.instance.currentTab.addListener(_onTabChanged);
    _requestPermissions();
    _checkGuide();
  }

  Future<void> _checkGuide() async {
    final hasSeen = await GuideService.hasSeenGuide();
    if (!hasSeen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGuide();
      });
    }
  }

  void _showGuide() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    GuideService.showGuide(
      context: context,
      keys: [_homeKey, _compendiumKey, _notesKey, _settingsKey, _mapKey],
      isMobile: isMobile,
    );
  }

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _compendiumKey = GlobalKey();
  final GlobalKey _notesKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _mapKey = GlobalKey();

  Future<void> _requestPermissions() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await [
        Permission.storage,
        Permission.photos,
      ].request();
    }
  }

  void _onTabChanged() {
    final newIndex = AppNavigation.instance.currentTab.value;
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
      // Muovi la pagina se l'indice cambia da fuori (es. tap sulla barra)
      if (_pageController.hasClients) {
        _pageController.jumpToPage(newIndex);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    AppNavigation.instance.currentTab.removeListener(_onTabChanged);
    super.dispose();
  }

  List<Widget> get _pages => [
    HomeView(onShowGuide: _showGuide),
    const CompendiumView(),
    const NotesView(),
    const SettingsView(),
    const MapTabView(),
  ];

  @override
  Widget build(BuildContext context) {
    // Breakpoint per determinare il layout:
    // Sotto i 600px -> mobile (Bottom NavigationBar)
    // Sopra i 600px -> tablet/desktop (NavigationRail)
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                AppNavigation.instance.currentTab.value = index;
              },
              extended: screenWidth >= 1000,
              destinations: [
                NavigationRailDestination(
                  icon: SizedBox(key: _currentIndex == 0 ? null : _homeKey, child: Image.asset('lib/assets/icone/Misc/Lantern.png', width: 24, height: 24)),
                  selectedIcon: SizedBox(key: _currentIndex == 0 ? _homeKey : null, child: Image.asset('lib/assets/icone/Misc/Lantern.png', width: 24, height: 24)),
                  label: Text(AppLocalizations.of(context)!.chronicles),
                ),
                NavigationRailDestination(
                  icon: SizedBox(key: _currentIndex == 1 ? null : _compendiumKey, child: Image.asset('lib/assets/icone/Misc/Book 2.png', width: 24, height: 24)),
                  selectedIcon: SizedBox(key: _currentIndex == 1 ? _compendiumKey : null, child: Image.asset('lib/assets/icone/Misc/Book 2.png', width: 24, height: 24)),
                  label: Text(AppLocalizations.of(context)!.lore),
                ),
                NavigationRailDestination(
                  icon: SizedBox(key: _currentIndex == 2 ? null : _notesKey, child: Image.asset('lib/assets/icone/Misc/Scroll.png', width: 24, height: 24)),
                  selectedIcon: SizedBox(key: _currentIndex == 2 ? _notesKey : null, child: Image.asset('lib/assets/icone/Misc/Scroll.png', width: 24, height: 24)),
                  label: Text(AppLocalizations.of(context)!.memories),
                ),
                NavigationRailDestination(
                  icon: SizedBox(key: _currentIndex == 3 ? null : _settingsKey, child: Image.asset('lib/assets/icone/Misc/Gear.png', width: 24, height: 24)),
                  selectedIcon: SizedBox(key: _currentIndex == 3 ? _settingsKey : null, child: Image.asset('lib/assets/icone/Misc/Gear.png', width: 24, height: 24)),
                  label: Text(AppLocalizations.of(context)!.info),
                ),
                NavigationRailDestination(
                  icon: SizedBox(key: _currentIndex == 4 ? null : _mapKey, child: Image.asset('lib/assets/icone/Misc/Map.png', width: 24, height: 24)),
                  selectedIcon: SizedBox(key: _currentIndex == 4 ? _mapKey : null, child: Image.asset('lib/assets/icone/Misc/Map.png', width: 24, height: 24)),
                  label: Text(AppLocalizations.of(context)!.cartography ?? AppLocalizations.of(context)!.maps), // Fallback in case of cartography being removed
                ),
              ],
            ),
            
          // Separatore leggero tra la rail e il contenuto
          if (!isMobile)
            const VerticalDivider(
              thickness: 1, 
              width: 1, 
              color: AppColors.surfaceSecondary,
            ),
            
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  // Aggiorna l'indice globale quando l'utente fa swipe
                  if (index != _currentIndex) {
                    AppNavigation.instance.currentTab.value = index;
                  }
                },
                physics: _currentIndex == 4 // 4 è l'indice di MapTabView
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                children: _pages,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                AppNavigation.instance.currentTab.value = index;
              },
              destinations: [
                NavigationDestination(
                  key: _homeKey,
                  icon: Image.asset('lib/assets/icone/Misc/Lantern.png', width: 32, height: 32),
                  selectedIcon: Image.asset('lib/assets/icone/Misc/Lantern.png', width: 32, height: 32),
                  label: AppLocalizations.of(context)!.chronicles,
                ),
                NavigationDestination(
                  key: _compendiumKey,
                  icon: Image.asset('lib/assets/icone/Misc/Book 2.png', width: 32, height: 32),
                  selectedIcon: Image.asset('lib/assets/icone/Misc/Book 2.png', width: 32, height: 32),
                  label: AppLocalizations.of(context)!.lore,
                ),
                NavigationDestination(
                  key: _notesKey,
                  icon: Image.asset('lib/assets/icone/Misc/Scroll.png', width: 32, height: 32),
                  selectedIcon: Image.asset('lib/assets/icone/Misc/Scroll.png', width: 32, height: 32),
                  label: AppLocalizations.of(context)!.memories,
                ),
                NavigationDestination(
                  key: _settingsKey,
                  icon: Image.asset('lib/assets/icone/Misc/Gear.png', width: 32, height: 32),
                  selectedIcon: Image.asset('lib/assets/icone/Misc/Gear.png', width: 32, height: 32),
                  label: AppLocalizations.of(context)!.info,
                ),
                NavigationDestination(
                  key: _mapKey,
                  icon: Image.asset('lib/assets/icone/Misc/Map.png', width: 32, height: 32),
                  selectedIcon: Image.asset('lib/assets/icone/Misc/Map.png', width: 32, height: 32),
                  label: AppLocalizations.of(context)!.cartography ?? AppLocalizations.of(context)!.maps, // Fallback
                ),
              ],
            )
          : null,
    );
  }
}
