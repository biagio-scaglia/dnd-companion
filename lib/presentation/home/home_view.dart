import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_shadows.dart';
import '../../features/notes/presentation/notes_controller.dart';
import '../widgets/dnd_card.dart';
import '../widgets/dnd_button.dart';

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
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Fa partire l'animazione all'apertura della view
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
    final result = _random.nextInt(sides) + 1;
    setState(() {
      _lastRollResult = 'Hai lanciato un d$sides... Risultato: $result';
    });
  }

  void _generateLoot() {
    final result = _lootTable[_random.nextInt(_lootTable.length)];
    setState(() {
      _lastLootResult = result;
    });
  }

  Widget _buildSeparateCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceSecondary.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDiceButton(String label, int sides) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _rollDice(sides),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.surfaceSecondary.withOpacity(0.5)),
          ),
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
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
              // Header
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'D&D COMPANION',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bentornato, Viaggiatore',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Lancio Dadi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              
              // Lancio Dadi
              DndCard(
                padding: const EdgeInsets.all(24),
                gradientColors: [
                  AppColors.surface,
                  AppColors.surfaceSecondary.withOpacity(0.5),
                ],
                shadow: AppShadows.glow(AppColors.highlight, opacity: 0.05),
                borderColor: AppColors.highlight.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceSecondary),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.casino_rounded, color: AppColors.magicAccent, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _lastRollResult,
                              style: const TextStyle(
                                color: AppColors.textPrimary, 
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
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
              const SizedBox(height: 32),
              
              const Text(
                'Dal Compendio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              
              // Compendio Highlight (Premium Card)
              DndCard(
                padding: const EdgeInsets.all(20),
                gradientColors: [
                  AppColors.surface,
                  Colors.black.withOpacity(0.3),
                ],
                shadow: AppShadows.glow(AppColors.magicAccent, opacity: 0.05),
                borderColor: AppColors.magicAccent.withOpacity(0.2),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.magicAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.magicAccent.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.auto_stories_rounded, color: AppColors.magicAccent, size: 32),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MOSTRI DEL GIORNO',
                            style: TextStyle(
                              color: AppColors.magicAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Beholder',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Grado Sfida 13 • Aberrazione',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSecondary.withOpacity(0.5), size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Generatore Rapido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              
              // Generatore di Bottino
              DndCard(
                padding: const EdgeInsets.all(20),
                gradientColors: [
                  AppColors.surface,
                  AppColors.surfaceSecondary.withOpacity(0.3),
                ],
                shadow: AppShadows.glow(AppColors.naturalAccent, opacity: 0.05),
                borderColor: AppColors.naturalAccent.withOpacity(0.2),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.naturalAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.card_giftcard_rounded, color: AppColors.naturalAccent, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BOTTINO CASUALE',
                            style: TextStyle(
                              color: AppColors.naturalAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _lastLootResult,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DndButton(
                      text: 'Genera',
                      onPressed: _generateLoot,
                      backgroundColor: AppColors.naturalAccent,
                      foregroundColor: AppColors.background,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'I Tuoi Contenuti',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              
              // Riepilogo Dati con Card Separate
              Consumer<NotesController>(
                builder: (context, notesController, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildSeparateCard(
                          'Note',
                          notesController.notes.length.toString(),
                          Icons.note_rounded,
                          AppColors.highlight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSeparateCard(
                          'Sessioni',
                          notesController.sessions.length.toString(),
                          Icons.menu_book_rounded,
                          AppColors.magicAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSeparateCard(
                          'Allegati',
                          notesController.attachments.length.toString(),
                          Icons.attach_file_rounded,
                          AppColors.naturalAccent,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              
              // Info dell'App
              const Center(
                child: Text(
                  'D&D Companion v1.0.0\nCreato per veri avventurieri',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
