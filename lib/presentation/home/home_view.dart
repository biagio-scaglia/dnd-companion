import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/app_navigation.dart';
import '../../features/notes/presentation/notes_controller.dart';
import '../../features/map/presentation/controllers/map_editor_controller.dart';
import '../../features/settings/presentation/settings_controller.dart';
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
  final VoidCallback? onShowGuide;
  const HomeView({super.key, this.onShowGuide});

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

  String _getLootTranslation(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'tapGenerate': return l10n.emptyLoot;
      case 'goldCoins': return l10n.goldCoins;
      case 'healingPotion': return l10n.healingPotion;
      case 'gem50': return l10n.gem50;
      case 'swordPlus1': return l10n.swordPlus1;
      case 'silverRing': return l10n.silverRing;
      case 'treasureMap': return l10n.treasureMap;
      case 'magicMissileScroll': return l10n.magicMissileScroll;
      case 'rustyKey': return l10n.rustyKey;
      default: return key;
    }
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
              final lang = context.watch<SettingsController>().settings.locale;
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        style: AppTypography.display.copyWith(
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Switch lingua
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          context.read<SettingsController>().setLocale(value);
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'it',
                            child: Text('Italiano'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'en',
                            child: Text('English'),
                          ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.highlight.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lang.toUpperCase(),
                                style: AppTypography.label.copyWith(color: AppColors.highlight),
                              ),
                              const Icon(Icons.arrow_drop_down, color: AppColors.highlight, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).slideIn(delay: const Duration(milliseconds: 100)),
                  
                  // Pulsante Guida manuale
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DndButton(
                      text: AppLocalizations.of(context)!.guide,
                      onPressed: () {
                        if (widget.onShowGuide != null) {
                          widget.onShowGuide!();
                        }
                      },
                      backgroundColor: AppColors.surfaceSecondary,
                      foregroundColor: AppColors.magicAccent,
                      isSmall: true,
                    ),
                  ).slideIn(delay: const Duration(milliseconds: 150)),
                  
              const DndOrnamentalDivider(space: 32),

              // ── Lancio Dadi ─────────────────────────────────────────
              DndSectionHeader(
                title: AppLocalizations.of(context)!.diceRoll,
                accentColor: AppColors.highlight,
              ).slideIn(delay: const Duration(milliseconds: 200)),
              const SizedBox(height: AppSpacing.m),

              const DiceRollerWidget().slideIn(delay: const Duration(milliseconds: 250)),
              const SizedBox(height: AppSpacing.xl),
              
              // ── Mappe ────────────────────────────────────────
              Consumer<MapEditorController>(
                builder: (context, mapController, child) {
                  final mapName = mapController.currentMap?.name ?? AppLocalizations.of(context)!.noMap;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DndSectionHeader(
                        title: AppLocalizations.of(context)!.maps,
                        accentColor: AppColors.magicAccent,
                      ),
                      const SizedBox(height: AppSpacing.m),
                      DndCard(
                        showGlow: true,
                        accentColor: AppColors.magicAccent,
                        padding: const EdgeInsets.all(16),
                        onTap: () => AppNavigation.instance.currentTab.value = 4,
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
                                    AppLocalizations.of(context)!.lastMap,
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
                title: AppLocalizations.of(context)!.compendium,
                accentColor: AppColors.magicAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              const CompendiumPreviewWidget(),
              const SizedBox(height: AppSpacing.xl),

              // ── Generatore Bottino ────────────────────────────────────
              DndSectionHeader(
                title: AppLocalizations.of(context)!.generator,
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
                            AppLocalizations.of(context)!.loot,
                            style: AppTypography.sectionLabel(color: AppColors.naturalAccent),
                          ),
                          const SizedBox(height: 4),
                          Text(_getLootTranslation(context, context.watch<HomeController>().lastLootResult), style: AppTypography.h3),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    DndButton(
                      text: AppLocalizations.of(context)!.generate,
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
                title: AppLocalizations.of(context)!.contents,
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
                      message: AppLocalizations.of(context)!.noContent,
                      subMessage: AppLocalizations.of(context)!.addContent,
                      accentColor: AppColors.highlight,
                      isCompact: true,
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: DndStatCard(
                          label: AppLocalizations.of(context)!.notes,
                          value: noteCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Scroll.png',
                          accentColor: AppColors.highlight,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: AppLocalizations.of(context)!.sessions,
                          value: sessionCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Book 2.png',
                          accentColor: AppColors.magicAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: AppLocalizations.of(context)!.characters,
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
  ));
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
