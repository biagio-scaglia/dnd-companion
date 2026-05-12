import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/dnd_card.dart';
import '../home_controller.dart';
import 'dice_roller_dialog.dart';

class DiceRollerWidget extends StatelessWidget {
  const DiceRollerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DndCard(
      variant: DndCardVariant.featured,
      accentColor: AppColors.highlight,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tira Dadi',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDiceButton(context, 'd20', 20),
              _buildDiceButton(context, 'd12', 12),
              _buildDiceButton(context, 'd10', 10),
              _buildDiceButton(context, 'd8', 8),
              _buildDiceButton(context, 'd6', 6),
              _buildDiceButton(context, 'd4', 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiceButton(BuildContext context, String label, int sides) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => DiceRollerDialog(initialDice: sides),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.highlight.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/dices/$label.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: AppTypography.label.copyWith(
                color: AppColors.textPrimary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
