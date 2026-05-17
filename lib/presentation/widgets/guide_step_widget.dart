import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GuideStepWidget extends StatelessWidget {
  final String title;
  final String description;
  final TutorialCoachMarkController controller;
  final int currentStep;
  final int totalSteps;

  const GuideStepWidget({
    super.key,
    required this.title,
    required this.description,
    required this.controller,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bool isLastStep = currentStep == totalSteps;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400), // Evita balloon enormi su tablet
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.magicAccent.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header: Titolo + Contatore Step
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        color: AppColors.magicAccent,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$currentStep / $totalSteps',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Descrizione scrollabile se troppo lunga
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Bottoni di navigazione
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottone Indietro (o vuoto se è il primo step)
                  if (currentStep > 1)
                    TextButton.icon(
                      onPressed: () => controller.previous(),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: Text(
                        // Manca una stringa "Indietro" dedicata, quindi usiamo un fallback
                        loc.skip, // in realta useremo solo l'icona
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    )
                  else
                    // Pulsante "Salta" visibile solo nel primo step per pulizia visiva
                    TextButton(
                      onPressed: () => controller.skip(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(loc.skip),
                    ),
                    
                  // Bottone Avanti / Fine
                  ElevatedButton(
                    onPressed: () {
                      if (isLastStep) {
                        controller.skip(); // Chiude il tutorial simulando uno skip (in alternativa next chiude se è alla fine)
                      } else {
                        controller.next();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.magicAccent,
                      foregroundColor: AppColors.surface,
                      elevation: 0,
                      minimumSize: const Size(100, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isLastStep ? loc.finish : loc.next,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
