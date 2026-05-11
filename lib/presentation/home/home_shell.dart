import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';
import '../../features/compendium/presentation/compendium_view.dart';
import '../../features/notes/presentation/notes_view.dart';
import '../../features/map/presentation/map_tab_view.dart';
import '../../features/settings/presentation/settings_view.dart';
import '../../core/utils/app_navigation.dart';
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
    _requestPermissions();
  }

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
      if (_pageController.hasClients && _pageController.page?.round() != newIndex) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    AppNavigation.instance.currentTab.removeListener(_onTabChanged);
    super.dispose();
  }

  final List<Widget> _pages = const [
    HomeView(),
    CompendiumView(),
    NotesView(),
    SettingsView(),
    MapTabView(),
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
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book_rounded),
                  label: Text('Compendio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit_note_outlined),
                  selectedIcon: Icon(Icons.edit_note_rounded),
                  label: Text('Appunti'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: Text('Info'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.map_outlined),
                  selectedIcon: Icon(Icons.map_rounded),
                  label: Text('Mappa'),
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
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book_rounded),
                  label: 'Compendio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.edit_note_outlined),
                  selectedIcon: Icon(Icons.edit_note_rounded),
                  label: 'Appunti',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Info',
                ),
                NavigationDestination(
                  icon: Icon(Icons.map_outlined),
                  selectedIcon: Icon(Icons.map_rounded),
                  label: 'Mappa',
                ),
              ],
            )
          : null,
    );
  }
}
