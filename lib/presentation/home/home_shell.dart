import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/compendium/presentation/compendium_view.dart';
import 'home_view.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    CompendiumView(),
    Center(child: Text('Personaggio - Presto in arrivo', style: TextStyle(color: Colors.white))),
    Center(child: Text('Impostazioni - Presto in arrivo', style: TextStyle(color: Colors.white))),
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
                setState(() {
                  _currentIndex = index;
                });
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
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: Text('Personaggio'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: Text('Impostazioni'),
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
              // Usiamo IndexedStack per mantenere lo stato delle view quando cambiamo tab
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
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
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Personaggio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings_rounded),
                  label: 'Impostazioni',
                ),
              ],
            )
          : null,
    );
  }
}
