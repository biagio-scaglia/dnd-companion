import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_mystic_icon_circle.dart';
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
            imagePath = 'lib/assets/icone/Monster Part/Skull.png';
          }
        } else {
          imagePath = 'lib/assets/icone/Monster Part/Skull.png';
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
            imagePath = 'lib/assets/icone/Misc/Scroll.png';
          }
        } else {
          imagePath = 'lib/assets/icone/Misc/Scroll.png';
        }
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.item:
        if (item.name.toLowerCase().contains('sword') || 
            item.name.toLowerCase().contains('blade')) {
          imagePath = 'lib/assets/weapon/sword.svg';
        } else if (item.name.toLowerCase().contains('dagger')) {
          imagePath = 'lib/assets/weapon/dagger.svg';
        } else if (item.name.toLowerCase().contains('axe')) {
          imagePath = 'lib/assets/weapon/battleaxe.svg';
        } else if (item.name.toLowerCase().contains('bow')) {
          imagePath = 'lib/assets/weapon/bow.svg';
        } else if (item.name.toLowerCase().contains('staff')) {
          imagePath = 'lib/assets/weapon/staff.svg';
        } else {
          imagePath = 'lib/assets/icone/Equipment/Iron Armor.png';
        }
        typeColor = AppColors.highlight;
        break;
      case CompendiumItemType.characterClass:
        if (knownClassIcons.contains(item.id.toLowerCase())) {
          imagePath = 'lib/assets/class/${item.id}.svg';
        } else {
          imagePath = null;
          typeIcon = Icons.book;
        }
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.race:
        imagePath = null;
        typeIcon = Icons.people;
        typeColor = AppColors.naturalAccent;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DndCard(
        showGlow: item.isFavorite,
        accentColor: AppColors.danger,
        padding: const EdgeInsets.all(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF120B07), // Sfondo scuro e profondo
                    borderRadius: BorderRadius.circular(8), // Angoli leggermente smussati
                    border: Border.all(
                      color: const Color(0xFF5C4033), // Bordo marrone scuro/legno
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2), // Ombra sotto
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: imagePath != null 
                        ? (imagePath!.endsWith('.svg')
                            ? SvgPicture.asset(
                                imagePath!,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(typeColor, BlendMode.srcIn),
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(typeIcon ?? Icons.help_outline_rounded, color: typeColor, size: 24);
                                },
                              )
                            : Image.asset(
                                imagePath!,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.none,
                              ))
                        : Icon(typeIcon, color: typeColor, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTypography.h3),
                      if (item.metaInfo != null) ...[
                        const SizedBox(height: 6),
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
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: Icon(
                    item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: item.isFavorite ? AppColors.danger : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                final acValue = acMatch != null ? acMatch.group(1)! : null;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (beforeHp.isNotEmpty)
                      Text(
                        beforeHp.endsWith('.') ? beforeHp.substring(0, beforeHp.length - 1) : beforeHp,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/icone/Misc/Heart.png',
                          width: 14,
                          height: 14,
                          filterQuality: FilterQuality.none,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$hpValue',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (acValue != null) ...[
                          const SizedBox(width: 12),
                          Image.asset(
                            'lib/assets/icone/Weapon & Tool/Iron Shield.png',
                            width: 14,
                            height: 14,
                            filterQuality: FilterQuality.none,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$acValue',
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
                style: AppTypography.bodySmall,
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
