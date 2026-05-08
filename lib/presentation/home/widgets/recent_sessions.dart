import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RecentSessions extends StatelessWidget {
  const RecentSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sessioni Recenti',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ricapitola quello che è successo',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Vedi Tutte',
                style: TextStyle(
                  color: AppColors.highlight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSessionTile(
          title: 'Il Lamento della Banshee',
          date: '14 Maggio 2026',
          description: 'Il party ha affrontato gli spiriti nelle cripte e trovato il medaglione antico.',
          isNew: true,
        ),
        const SizedBox(height: 12),
        _buildSessionTile(
          title: 'L\'Inganno alla Locanda',
          date: '7 Maggio 2026',
          description: 'Trattative con la Gilda dei Ladri per ottenere l\'accesso alle fogne. Ottenuta la mappa del dungeon, ma abbiamo perso un prezioso alleato durante la fuga.',
          isNew: false,
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Niente si perde tra una sessione e l\'altra',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTile({
    required String title,
    required String date,
    required String description,
    required bool isNew,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        highlightColor: AppColors.surfaceSecondary.withOpacity(0.5),
        splashColor: AppColors.highlight.withOpacity(0.1),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.surfaceSecondary,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isNew)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.magicAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Nuovo',
                        style: TextStyle(
                          color: AppColors.magicAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
