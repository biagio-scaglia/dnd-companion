import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_chip.dart';
import '../../domain/models/compendium_item.dart';

class CompendiumItemCard extends StatelessWidget {
  final CompendiumItem item;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CompendiumItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  String _translateMetaInfo(BuildContext context, String metaInfo) {
    final l10n = AppLocalizations.of(context)!;
    if (metaInfo.startsWith('Spell') || metaInfo.startsWith('Incantesimo')) {
      return l10n.spell;
    }
    if (metaInfo == 'Mostro') return l10n.monster;
    if (metaInfo == 'Oggetto') return l10n.item;
    if (metaInfo == 'Classe') return l10n.classes;
    if (metaInfo == 'Razza') return l10n.races;
    return metaInfo;
  }

  @override
  Widget build(BuildContext context) {
    String? imagePath;
    IconData? typeIcon;
    Color typeColor;

    final knownMonsterIcons = ['aberration', 'beast', 'celestial', 'construct', 'dragon', 'elemental', 'fae', 'fiend', 'giant', 'humanoid', 'monstrosity', 'ooze', 'plant', 'undead'];
    final knownSpellIcons = ['abjuration', 'conjuration', 'divination', 'enchantment', 'evocation', 'illusion', 'necromancy', 'transmutation'];
    final knownClassIcons = ['artificer', 'barbarian', 'bard', 'cleric', 'druid', 'fighter', 'monk', 'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard'];

    switch (item.type) {
      case CompendiumItemType.monster:
        final desc = item.shortDescription;
        final typeMatch = RegExp(r'(aberration|beast|celestial|construct|dragon|elemental|fae|fiend|giant|humanoid|monstrosity|ooze|plant|undead)', caseSensitive: false).firstMatch(desc);
        if (typeMatch != null) {
          final mType = typeMatch.group(0)!.toLowerCase();
          if (knownMonsterIcons.contains(mType)) {
            imagePath = 'lib/assets/monster/$mType.svg';
          } else {
            imagePath = 'lib/assets/monster/monstrosity.svg';
          }
        } else {
          imagePath = 'lib/assets/monster/monstrosity.svg';
        }
        typeColor = AppColors.danger;
        break;
      case CompendiumItemType.spell:
        final meta = item.metaInfo ?? '';
        final schoolMatch = RegExp(r'\((.*?)\)').firstMatch(meta);
        if (schoolMatch != null) {
          final school = schoolMatch.group(1)!.toLowerCase();
          if (knownSpellIcons.contains(school)) {
            imagePath = 'lib/assets/spell/$school.svg';
          } else {
            typeIcon = Icons.auto_fix_high_rounded;
          }
        } else {
          typeIcon = Icons.auto_fix_high_rounded;
        }
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.item:
        final name = item.name.toLowerCase();
        if (name.contains('sword') || name.contains('blade') || name.contains('scimitar') || name.contains('rapier')) {
          imagePath = 'lib/assets/weapon/sword.svg';
        } else if (name.contains('dagger')) {
          imagePath = 'lib/assets/weapon/dagger.svg';
        } else if (name.contains('axe')) {
          imagePath = 'lib/assets/weapon/battleaxe.svg';
        } else if (name.contains('bow') || name.contains('crossbow')) {
          imagePath = 'lib/assets/weapon/bow.svg';
        } else if (name.contains('staff') || name.contains('wand') || name.contains('rod')) {
          imagePath = 'lib/assets/weapon/staff.svg';
        } else if (name.contains('mace') || name.contains('hammer') || name.contains('club') || name.contains('morningstar')) {
          imagePath = 'lib/assets/weapon/hammer.svg';
        } else if (name.contains('shield') || name.contains('armor') || name.contains('plate') || name.contains('mail') || name.contains('helm')) {
          typeIcon = Icons.shield_rounded;
        } else {
          typeIcon = Icons.inventory_2_rounded;
        }
        typeColor = AppColors.highlight;
        break;
      case CompendiumItemType.characterClass:
        if (knownClassIcons.contains(item.id.toLowerCase())) {
          imagePath = 'lib/assets/class/${item.id}.svg';
        } else {
          typeIcon = Icons.auto_stories_rounded;
        }
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.race:
        typeIcon = Icons.groups_rounded;
        typeColor = AppColors.naturalAccent;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DndCard(
        showGlow: item.isFavorite,
        accentColor: typeColor,
        borderColor: typeColor.withValues(alpha: 0.15),
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Centra verticalmente rispetto all'icona
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F0906), 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: typeColor.withValues(alpha: 0.5), 
                      width: 1.5,
                    ),
                  ),
                  child: imagePath != null 
                      ? SvgPicture.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          errorBuilder: (context, error, stackTrace) => Icon(typeIcon ?? Icons.help_outline, color: Colors.white, size: 20),
                        )
                      : Icon(typeIcon ?? Icons.help_outline, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name, 
                        style: AppTypography.h3.copyWith(
                          fontSize: 17,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                      if (item.metaInfo != null) ...[
                        const SizedBox(height: 4),
                        DndChip(
                          label: _translateMetaInfo(context, item.metaInfo!),
                          accentColor: typeColor,
                          isSelected: true,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: item.isFavorite ? AppColors.danger : AppColors.textSecondary.withValues(alpha: 0.3),
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            () {
              if (item.shortDescription == '__TAP_TO_LOAD_DETAILS__') {
                return Text(
                  AppLocalizations.of(context)!.tapToLoadDetails,
                  style: AppTypography.bodySmall,
                );
              }
              
              final hpMatch = RegExp(r'(.*?)HP:\s*(\d+)').firstMatch(item.shortDescription);
              final acMatch = RegExp(r'AC:\s*(\d+)').firstMatch(item.shortDescription);
              
              if (hpMatch != null) {
                final beforeHp = hpMatch.group(1)!.trim();
                final hpValue = hpMatch.group(2)!;
                final acValue = acMatch?.group(1);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (beforeHp.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          beforeHp.endsWith('.') ? beforeHp.substring(0, beforeHp.length - 1) : beforeHp,
                          style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: AppColors.danger, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          hpValue,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (acValue != null) ...[
                          const SizedBox(width: 14),
                          const Icon(Icons.shield_rounded, color: AppColors.highlight, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            acValue,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.highlight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              }
              
              return Text(
                item.shortDescription,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              );
            }(),
          ],
        ),
      ),
    );
  }
}
