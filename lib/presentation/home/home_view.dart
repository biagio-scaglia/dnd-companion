import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              // ── Header ──────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VELLUM',
                    style: AppTypography.label.copyWith(
                      color: AppColors.highlight,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bentornato, Viaggiatore',
                    style: AppTypography.display.copyWith(
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ).slideIn(delay: const Duration(milliseconds: 100)),
              const DndOrnamentalDivider(space: 32),

              // ── Lancio Dadi ─────────────────────────────────────────
              const DndSectionHeader(
                title: 'Lancio Dadi',
                subtitle: 'Tira i dadi per le tue prove',
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
                      const DndSectionHeader(
                        title: 'Mappe',
                        subtitle: 'Esplora e modifica i tuoi mondi',
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
                                    'ULTIMA MAPPA ATTIVA',
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
              const DndSectionHeader(
                title: 'Dal Compendio',
                subtitle: 'Ultimi segreti scoperti',
                accentColor: AppColors.magicAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              const CompendiumPreviewWidget(),
              const SizedBox(height: AppSpacing.xl),

              // ── Generatore Bottino ────────────────────────────────────
              const DndSectionHeader(
                title: 'Generatore Rapido',
                subtitle: 'Strumenti per il Dungeon Master',
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
                            'BOTTINO CASUALE',
                            style: AppTypography.sectionLabel(color: AppColors.naturalAccent),
                          ),
                          const SizedBox(height: 4),
                          Text(context.watch<HomeController>().lastLootResult, style: AppTypography.h3),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    DndButton(
                      text: 'Genera',
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
              const DndSectionHeader(
                title: 'I Tuoi Contenuti',
                subtitle: 'Riepilogo delle tue risorse',
                accentColor: AppColors.textSecondary,
              ),
              const SizedBox(height: AppSpacing.m),

              Consumer<NotesController>(
                builder: (context, notesController, child) {
                  final noteCount = notesController.notes.length;
                  final sessionCount = notesController.sessions.length;
                  final charCount = notesController.characters.length;

                  if (noteCount == 0 && sessionCount == 0 && charCount == 0) {
                    return const DndEmptyState(
                      icon: Icons.book_outlined,
                      message: 'Nessun contenuto ancora',
                      subMessage: 'Aggiungi note, sessioni o personaggi dalla tab Appunti',
                      accentColor: AppColors.highlight,
                      isCompact: true,
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: DndStatCard(
                          label: 'Note',
                          value: noteCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Scroll.png',
                          accentColor: AppColors.highlight,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: 'Sessioni',
                          value: sessionCount.toString(),
                          imagePath: 'lib/assets/icone/Misc/Book 2.png',
                          accentColor: AppColors.magicAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: 'Personaggi',
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
          ),
        ),
      ),
    );
  }
}
