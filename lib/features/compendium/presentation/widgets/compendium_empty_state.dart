import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CompendiumEmptyState extends StatelessWidget {
  final bool isFiltering;

  const CompendiumEmptyState({super.key, this.isFiltering = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltering ? Icons.search_off_rounded : Icons.auto_stories_rounded,
              size: 64,
              color: AppColors.surfaceSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              isFiltering ? 'Nessun risultato trovato...' : 'Il compendio è vuoto.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltering 
                  ? 'Prova a cercare con altre parole magiche.'
                  : 'Aggiungi elementi per popolare questo grimorio.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
