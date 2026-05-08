import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DiceRollerDialog extends StatefulWidget {
  const DiceRollerDialog({super.key});

  @override
  State<DiceRollerDialog> createState() => _DiceRollerDialogState();
}

class _DiceRollerDialogState extends State<DiceRollerDialog> with SingleTickerProviderStateMixin {
  int? _result;
  int? _lastDice;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _rollDice(int max) {
    _shakeController.forward(from: 0.0);
    setState(() {
      _result = Random().nextInt(max) + 1;
      _lastDice = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dice = [4, 6, 8, 10, 12, 20, 100];
    
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Tira Dadi', 
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_result != null)
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                final shakeOffset = sin(_shakeController.value * pi * 4) * 5;
                return Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 32, top: 16),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.magicAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.magicAccent.withOpacity(0.5), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'D$_lastDice', 
                      style: const TextStyle(
                        color: AppColors.magicAccent, 
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_result',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else 
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Scegli un dado da tirare',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: dice.map((d) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _rollDice(d),
                  borderRadius: BorderRadius.circular(16),
                  highlightColor: AppColors.magicAccent.withOpacity(0.2),
                  child: Ink(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _lastDice == d ? AppColors.magicAccent : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'D$d', 
                        style: TextStyle(
                          color: _lastDice == d ? AppColors.magicAccent : AppColors.textPrimary, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Chiudi', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
