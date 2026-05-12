import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_navigation.dart';
import '../data/repositories/compendium_repository_impl.dart';
import 'compendium_controller.dart';
import 'widgets/compendium_search_bar.dart';
import 'widgets/compendium_category_filters.dart';
import 'widgets/compendium_item_card.dart';
import 'widgets/compendium_empty_state.dart';
import 'compendium_detail_view.dart';
import 'widgets/add_custom_item_dialog.dart';
import '../domain/models/compendium_item.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/dnd_chip.dart';

class CompendiumView extends StatefulWidget {
  const CompendiumView({super.key});

  @override
  State<CompendiumView> createState() => _CompendiumViewState();
}

class _CompendiumViewState extends State<CompendiumView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late CompendiumController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = CompendiumController(repository: CompendiumRepositoryImpl());
    _controller.addListener(_onStateChanged);
    
    // Check initial filter at startup
    if (AppNavigation.instance.initialFilter.value != null) {
      _controller.setCategory(AppNavigation.instance.initialFilter.value!);
      AppNavigation.instance.initialFilter.value = null; // consume
    }
    
    // Listen for future changes
    AppNavigation.instance.initialFilter.addListener(_onInitialFilterChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  void _onInitialFilterChanged() {
    final filter = AppNavigation.instance.initialFilter.value;
    if (filter != null) {
      _controller.setCategory(filter);
      AppNavigation.instance.initialFilter.value = null; // consume
    }
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    AppNavigation.instance.initialFilter.removeListener(_onInitialFilterChanged);
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.highlight,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await showDialog<CompendiumItem>(
            context: context,
            builder: (ctx) => const AddCustomItemDialog(),
          );
          if (result != null) {
            _controller.addCustomItem(result);
          }
        },
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DndSectionHeader(
                    title: AppLocalizations.of(context)!.compendiumTitle,
                    subtitle: AppLocalizations.of(context)!.compendiumSubtitle,
                    accentColor: AppColors.magicAccent,
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 27, // "Tutti" + A-Z
                      itemBuilder: (context, index) {
                        final letters = [AppLocalizations.of(context)!.all, ...List.generate(26, (i) => String.fromCharCode(65 + i))];
                        final letter = letters[index];
                        final isSelected = (letter == AppLocalizations.of(context)!.all && _controller.filter.selectedLetter == null) ||
                            (_controller.filter.selectedLetter == letter);
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: DndChip(
                            label: letter,
                            accentColor: AppColors.magicAccent,
                            isSelected: isSelected,
                            onTap: () {
                              if (letter == AppLocalizations.of(context)!.all) {
                                _controller.setLetter(null);
                              } else {
                                _controller.setLetter(letter);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  CompendiumCategoryFilters(
                    selectedCategory: _controller.filter.selectedCategory,
                    showOnlyFavorites: _controller.filter.showOnlyFavorites,
                    onCategoryTapped: _controller.toggleCategory,
                    onFavoritesTapped: _controller.toggleFavoritesOnly,
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildBody(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return Center(
        key: const ValueKey('loading'),
        child: DndLoadingIndicator(message: AppLocalizations.of(context)!.loadingCompendium),
      );
    }

    if (_controller.items.isEmpty) {
      final isFiltering = _controller.filter.query.isNotEmpty || 
                          _controller.filter.selectedCategory != null ||
                          _controller.filter.showOnlyFavorites;
      return CompendiumEmptyState(
        key: const ValueKey('empty'),
        isFiltering: isFiltering,
      );
    }

    return ListView.builder(
      key: const ValueKey('list'),
      physics: const BouncingScrollPhysics(),
      itemCount: _controller.items.length,
      itemBuilder: (context, index) {
        final item = _controller.items[index];
        return CompendiumItemCard(
          key: ValueKey(item.id),
          item: item,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CompendiumDetailView(item: item),
              ),
            );
          },
          onFavoriteToggle: () {
            _controller.toggleFavoriteStatus(item.id);
          },
        );
      },
    );
  }
}
