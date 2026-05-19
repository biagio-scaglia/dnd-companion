import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/dnd_card.dart';
import '../../../features/compendium/domain/models/compendium_item.dart';
import '../../../features/compendium/presentation/compendium_detail_view.dart';

class CompendiumPreviewWidget extends StatelessWidget {
  const CompendiumPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final beholder = CompendiumItem(
          id: 'beholder',
          name: 'Beholder',
          type: CompendiumItemType.monster,
          shortDescription: 'GS 13 • ${AppLocalizations.of(context)!.aberration}',
          description: AppLocalizations.of(context)!.beholderDesc,
          metaInfo: 'GS 13',
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CompendiumDetailView(item: beholder)),
        );
      },
      child: DndCard(
        variant: DndCardVariant.featured,
        accentColor: AppColors.magicAccent,
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.magicAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.magicAccent.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Image.asset(
                  'lib/assets/icone/Misc/Book 3.png',
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.monsterOfTheDay.toUpperCase(),
                    style: AppTypography.sectionLabel(color: AppColors.magicAccent),
                  ),
                  const SizedBox(height: 4),
                  Text('Beholder', style: AppTypography.h2),
                  const SizedBox(height: 2),
                  Text(
                    'GS 13 • ${AppLocalizations.of(context)!.aberration}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
