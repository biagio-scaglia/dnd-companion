import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../features/notes/presentation/notes_controller.dart';
import '../widgets/dnd_card.dart';
import '../widgets/dnd_button.dart';
import '../widgets/dnd_section_title.dart';
import '../widgets/dnd_stat_card.dart';
import '../widgets/dnd_empty_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
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

  String _lastRollResult = 'Tocca un dado per lanciare';
  final Random _random = Random();

  String _lastLootResult = 'Tocca "Genera" per un bottino';
  final List<String> _lootTable = [
    '10 Monete d\'Oro',
    'Pozione di Guarigione',
    'Gemma Preziosa (50 mo)',
    'Spada Corta +1',
    'Anello d\'Argento antico',
    'Mappa del Tesoro sgualcita',
    'Pergamena di "Dardo Incantato"',
    'Chiave di Ferro arrugginita',
  ];

  void _rollDice(int sides) {
    setState(() {
      final result = _random.nextInt(sides) + 1;
      _lastRollResult = 'd$sides → $result';
    });
  }

  void _generateLoot() {
    setState(() {
      _lastLootResult = _lootTable[_random.nextInt(_lootTable.length)];
    });
  }

  Widget _buildDiceButton(String label, int sides) {
    return GestureDetector(
      onTap: () => _rollDice(sides),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.highlight.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'D&D COMPANION',
                    style: AppTypography.label.copyWith(
                      color: AppColors.highlight,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Bentornato, Viaggiatore',
                    style: AppTypography.display,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Lancio Dadi ─────────────────────────────────────────
              DndSectionTitle(
                title: 'Lancio Dadi',
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.m),

              DndCard(
                variant: DndCardVariant.featured,
                accentColor: AppColors.highlight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Risultato
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceSecondary),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.casino_rounded, color: AppColors.highlight, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _lastRollResult,
                              style: AppTypography.h3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDiceButton('d20', 20),
                        _buildDiceButton('d12', 12),
                        _buildDiceButton('d10', 10),
                        _buildDiceButton('d8', 8),
                        _buildDiceButton('d6', 6),
                        _buildDiceButton('d4', 4),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Dal Compendio ────────────────────────────────────────
              DndSectionTitle(
                title: 'Dal Compendio',
                accentColor: AppColors.magicAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              DndCard(
                variant: DndCardVariant.featured,
                accentColor: AppColors.magicAccent,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.magicAccent.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.magicAccent.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: AppColors.magicAccent, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MOSTRO DEL GIORNO',
                            style: AppTypography.sectionLabel(color: AppColors.magicAccent),
                          ),
                          const SizedBox(height: 4),
                          Text('Beholder', style: AppTypography.h2),
                          const SizedBox(height: 2),
                          Text(
                            'GS 13 • Aberrazione',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Generatore Bottino ────────────────────────────────────
              DndSectionTitle(
                title: 'Generatore Rapido',
                accentColor: AppColors.naturalAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              DndCard(
                variant: DndCardVariant.featured,
                accentColor: AppColors.naturalAccent,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.naturalAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.card_giftcard_rounded, color: AppColors.naturalAccent, size: 22),
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
                          Text(_lastLootResult, style: AppTypography.h3),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    DndButton(
                      text: 'Genera',
                      onPressed: _generateLoot,
                      backgroundColor: AppColors.naturalAccent,
                      foregroundColor: AppColors.background,
                      isSmall: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── I Tuoi Contenuti ──────────────────────────────────────
              DndSectionTitle(
                title: 'I Tuoi Contenuti',
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
                      message: 'Nessun contenuto ancora',
                      subMessage: 'Aggiungi note, sessioni o personaggi dalla tab Appunti',
                      accentColor: AppColors.highlight,
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: DndStatCard(
                          label: 'Note',
                          value: noteCount.toString(),
                          icon: Icons.note_rounded,
                          accentColor: AppColors.highlight,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: 'Sessioni',
                          value: sessionCount.toString(),
                          icon: Icons.menu_book_rounded,
                          accentColor: AppColors.magicAccent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: DndStatCard(
                          label: 'Personaggi',
                          value: charCount.toString(),
                          icon: Icons.person_rounded,
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
                  'D&D Companion v1.0.0',
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
