import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/localization/app_strings.dart';
import '../../features/notes/presentation/notes_controller.dart';
import '../../features/map/presentation/controllers/map_editor_controller.dart';
import 'home_controller.dart';
import 'widgets/dice_roller_widget.dart';
import 'widgets/compendium_preview_widget.dart';
import '../widgets/dnd_button.dart';
import '../widgets/dnd_stat_card.dart';
import '../widgets/dnd_empty_state.dart';
import '../widgets/dnd_card.dart';
import '../widgets/dnd_section_header.dart';
import '../widgets/dnd_motion.dart';
import '../widgets/dnd_mystic_icon_circle.dart';
import '../widgets/dnd_ornamental_divider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: Consumer<HomeController>(
            builder: (context, homeController, child) {
              final lang = homeController.currentLanguage;
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('app_title', lang),
                            style: AppTypography.label.copyWith(
                              color: AppColors.highlight,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppStrings.get('welcome', lang),
                            style: AppTypography.display.copyWith(
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      // Switch lingua
                      Row(
                        children: [
                          _buildLanguageButton(context, 'IT', lang == 'it', () => homeController.setLanguage('it')),
                          const SizedBox(width: 8),
                          _buildLanguageButton(context, 'EN', lang == 'en', () => homeController.setLanguage('en')),
                        ],
                      ),
                    ],
                  ).slideIn(delay: const Duration(milliseconds: 100)),
              const DndOrnamentalDivider(space: 32),

              // ── Lancio Dadi ─────────────────────────────────────────
              DndSectionHeader(
                title: AppStrings.get('dice_roll', lang),
                subtitle: AppStrings.get('dice_roll_sub', lang),
                accentColor: AppColors.highlight,
              ).slideIn(delay: const Duration(milliseconds: 200)),
              const SizedBox(height: AppSpacing.m),

              const DiceRollerWidget().slideIn(delay: const Duration(milliseconds: 250)),
              const SizedBox(height: AppSpacing.xl),
              
              // ── Mappe ────────────────────────────────────────
              Consumer<MapEditorController>(
                builder: (context, mapController, child) {
                  final mapName = mapController.currentMap?.name ?? 'Nessuna mappa';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DndSectionHeader(
                        title: AppStrings.get('maps', lang),
                        subtitle: AppStrings.get('maps_sub', lang),
                        accentColor: AppColors.magicAccent,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      DndCard(
                        showGlow: true,
                        accentColor: AppColors.magicAccent,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const DndMysticIconCircle(
                              imagePath: 'lib/assets/icone/Misc/Map.png',
                              accentColor: AppColors.magicAccent,
                              size: 48,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.get('last_map', lang),
                                    style: AppTypography.sectionLabel(color: AppColors.magicAccent),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(mapName, style: AppTypography.h3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ).slideIn(delay: const Duration(milliseconds: 300)),

              const SizedBox(height: AppSpacing.xl),

              // ── Dal Compendio ────────────────────────────────────────
              DndSectionHeader(
                title: AppStrings.get('compendium', lang),
                subtitle: AppStrings.get('compendium_sub', lang),
                accentColor: AppColors.magicAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              const CompendiumPreviewWidget(),
              const SizedBox(height: AppSpacing.xl),

              // ── Generatore Bottino ────────────────────────────────────
              DndSectionHeader(
                title: AppStrings.get('generator', lang),
                subtitle: AppStrings.get('generator_sub', lang),
                accentColor: AppColors.naturalAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              DndCard(
                showGlow: true,
                accentColor: AppColors.naturalAccent,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const DndMysticIconCircle(
                      imagePath: 'lib/assets/icone/Misc/Chest.png',
                      accentColor: AppColors.naturalAccent,
                      size: 44,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.get('loot', lang),
                            style: AppTypography.sectionLabel(color: AppColors.naturalAccent),
                          ),
                          const SizedBox(height: 4),
                          Text(context.watch<HomeController>().lastLootResult, style: AppTypography.h3),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    DndButton(
                      text: AppStrings.get('generate', lang),
                      onPressed: () => context.read<HomeController>().generateLoot(),
                      backgroundColor: AppColors.naturalAccent,
                      foregroundColor: AppColors.background,
                      isSmall: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── I Tuoi Contenuti ──────────────────────────────────────
              DndSectionHeader(
                title: AppStrings.get('contents', lang),
                subtitle: AppStrings.get('contents_sub', lang),
                accentColor: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.m),

              Consumer<NotesController>(
                builder: (context, notesController, child) {
                  final noteCount = notesController.notes.length;
                  final sessionCount = notesController.sessions.length;
                  final charCount = notesController.characters.length;

                  if (noteCount == 0 && sessionCount == 0 && charCount == 0) {
                    return DndEmptyState(
                      icon: Icons.book_outlined,
                      message: AppStrings.get('no_content', lang),
                      subMessage: AppStrings.get('add_content', lang),
                      accentColor: AppColors.highlight,
                      isCompact: true,
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: DndStatCard(
                          label: AppStrings.get('notes', lang),
                          value: noteCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Scroll.png',
                          accentColor: AppColors.highlight,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: AppStrings.get('sessions', lang),
                          value: sessionCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Book 2.png',
                          accentColor: AppColors.magicAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: AppStrings.get('characters', lang),
                          value: charCount.toString(),
                          imagePath: 'lib/assets/icone/Equipment/Helm.png',
                          accentColor: AppColors.naturalAccent,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Footer
              Center(
                child: Text(
                  'Vellum v1.0.0',
                  style: AppTypography.caption,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
            ],
          );
        },
      ),
    ),
  );
}

Widget _buildLanguageButton(BuildContext context, String label, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.highlight.withValues(alpha: 0.2) : AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? AppColors.highlight : AppColors.surfaceSecondary,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: isSelected ? AppColors.highlight : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
}
