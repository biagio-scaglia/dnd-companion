import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DiceRollerDialog extends StatefulWidget {
  final int? initialDice;
  const DiceRollerDialog({super.key, this.initialDice});

  @override
  State<DiceRollerDialog> createState() => _DiceRollerDialogState();
}

class _DiceRollerDialogState extends State<DiceRollerDialog> with SingleTickerProviderStateMixin {
  int? _result;
  int? _currentRoll;
  int? _lastDice;
  int _modifier = 0;
  final List<String> _history = [];
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (widget.initialDice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _rollDice(widget.initialDice!);
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _rollDice(int max) {
    _shakeController.forward(from: 0.0);
    setState(() {
      final roll = Random().nextInt(max) + 1;
      _currentRoll = roll;
      _result = roll + _modifier;
      _lastDice = max;
      
      // Salva nella storia con il dettaglio del modificatore
      String historyEntry = '$roll';
      if (_modifier > 0) historyEntry += ' (+$_modifier)';
      if (_modifier < 0) historyEntry += ' ($_modifier)';
      historyEntry += ' = $_result';
      
      _history.insert(0, historyEntry);
      if (_history.length > 5) {
        _history.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dice = [4, 6, 8, 10, 12, 20]; // Rimosso 100!
    
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
          if (_result != null && _currentRoll != null)
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                // Animazione di scossa più accentuata
                final shakeOffset = sin(_shakeController.value * pi * 6) * 8;
                return Transform.translate(
                  offset: Offset(shakeOffset, 0),
                  child: child,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24, top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.magicAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.magicAccent.withValues(alpha: 0.3), width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      'D$_lastDice${_modifier != 0 ? (_modifier > 0 ? ' +$_modifier' : ' $_modifier') : ''}', 
                      style: const TextStyle(
                        color: AppColors.textSecondary, 
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 12),
                    // Immagine del dado con il risultato!
                    Image.asset(
                      'lib/assets/dadi/D$_lastDice/d${_lastDice}_yellow_$_currentRoll.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback se l'immagine non esiste!
                        return Text(
                          '$_currentRoll',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                    if (_modifier != 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Risultato: $_result',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.magicAccent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
          else 
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'Scegli un dado da tirare',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            
          // ── Modificatori Rapidi ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildModifierChip(-1),
              const SizedBox(width: 8),
              _buildModifierChip(0, label: 'Reset'),
              const SizedBox(width: 8),
              _buildModifierChip(1),
              const SizedBox(width: 8),
              _buildModifierChip(2),
            ],
          ),
          const SizedBox(height: 16),
          
          // ── Griglia Dadi ─────────────────────────────────────────────
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: dice.map((d) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _rollDice(d),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    width: 56,
                    height: 56,
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
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          // ── Storia dei Tiri ──────────────────────────────────────────
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Ultimi tiri:', 
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: _history.map((h) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  h, 
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)
                ),
              )).toList(),
            ),
          ],
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

  Widget _buildModifierChip(int value, {String? label}) {
    final isSelected = _modifier == value;
    final displayLabel = label ?? (value > 0 ? '+$value' : '$value');
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _modifier = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.magicAccent.withValues(alpha: 0.2) : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.magicAccent : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          displayLabel,
          style: TextStyle(
            color: isSelected ? AppColors.magicAccent : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
