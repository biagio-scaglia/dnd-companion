import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/dnd_card.dart';
import 'dice_roller_dialog.dart';

class DiceRollerWidget extends StatefulWidget {
  const DiceRollerWidget({super.key});

  @override
  State<DiceRollerWidget> createState() => _DiceRollerWidgetState();
}

class _DiceRollerWidgetState extends State<DiceRollerWidget> {
  final List<Map<String, dynamic>> _diceList = [
    {'label': 'd20', 'sides': 20},
    {'label': 'd12', 'sides': 12},
    {'label': 'd10', 'sides': 10},
    {'label': 'd8', 'sides': 8},
    {'label': 'd6', 'sides': 6},
    {'label': 'd4', 'sides': 4},
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _diceList.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDice = _diceList[_currentIndex];
    
    return DndCard(
      variant: DndCardVariant.featured,
      accentColor: AppColors.highlight,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => DiceRollerDialog(initialDice: currentDice['sides']),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.diceRoll,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.tapToRoll,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Column(
                  key: ValueKey<int>(_currentIndex),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/assets/dices/${currentDice['label']}.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentDice['label'].toString().toUpperCase(),
                      style: AppTypography.label.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
