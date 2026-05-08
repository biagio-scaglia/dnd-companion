import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/repositories/compendium_repository_impl.dart';
import 'compendium_controller.dart';
import 'widgets/compendium_search_bar.dart';
import 'widgets/compendium_category_filters.dart';
import 'widgets/compendium_item_card.dart';
import 'widgets/compendium_empty_state.dart';
import 'compendium_detail_view.dart';

class CompendiumView extends StatefulWidget {
  const CompendiumView({super.key});

  @override
  State<CompendiumView> createState() => _CompendiumViewState();
}

class _CompendiumViewState extends State<CompendiumView> with SingleTickerProviderStateMixin {
  late CompendiumController _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Instanziamo il controller
    _controller = CompendiumController(repository: CompendiumRepositoryImpl());
    _controller.addListener(_onStateChanged);

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

  void _onStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Compendio',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cerca conoscenze e antichi segreti.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                
                CompendiumSearchBar(
                  onChanged: (val) => _controller.setQuery(val),
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
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(color: AppColors.highlight),
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
