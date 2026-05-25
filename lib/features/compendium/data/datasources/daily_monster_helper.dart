import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../domain/models/compendium_item.dart';

class DailyMonsterHelper {
  // Stable offline fallbacks
  static const List<CompendiumItem> _fallbackMonsters = [
    CompendiumItem(
      id: 'beholder',
      name: 'Beholder',
      type: CompendiumItemType.monster,
      shortDescription: 'GS 13 • Aberration',
      description: 'A large floating eye with many smaller eyes on stalks. It is one of the most iconic monsters in D&D.',
      metaInfo: 'GS 13',
    ),
    CompendiumItem(
      id: 'goblin',
      name: 'Goblin',
      type: CompendiumItemType.monster,
      shortDescription: 'GS 1/4 • Small humanoid',
      description: 'Goblins are small, black-hearted, selfish creatures that live in caves, dungeons, or hidden camps.',
      metaInfo: 'GS 1/4',
    ),
    CompendiumItem(
      id: 'ancient_red_dragon',
      name: 'Ancient Red Dragon',
      type: CompendiumItemType.monster,
      shortDescription: 'GS 24 • Gargantuan dragon',
      description: 'The odor of sulfur and pumice surrounds red dragons. They are the most covetous of all true dragons.',
      metaInfo: 'GS 24',
    ),
  ];

  /// Get the daily monster deterministically.
  static CompendiumItem getDailyMonster(List<CompendiumItem> databaseMonsters, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    
    // Deterministic daily seed: year * 365 + month * 31 + day
    final daySeed = targetDate.year * 365 + targetDate.month * 31 + targetDate.day;
    
    final listToUse = databaseMonsters.isNotEmpty ? databaseMonsters : _fallbackMonsters;
    
    // Deterministic index calculation
    final index = daySeed % listToUse.length;
    
    return listToUse[index];
  }

  /// Returns a localized version of a monster if it's one of the fallbacks/known items.
  static CompendiumItem getLocalizedItem(BuildContext context, CompendiumItem item) {
    final l10n = AppLocalizations.of(context)!;
    final isIt = Localizations.localeOf(context).languageCode == 'it';

    if (item.id == 'beholder') {
      return item.copyWith(
        shortDescription: 'GS 13 • ${l10n.aberration}',
        description: l10n.beholderDesc,
      );
    }
    
    if (item.id == 'goblin' || item.id == 'm1') {
      if (isIt) {
        return item.copyWith(
          name: 'Goblin',
          shortDescription: 'Sfida 1/4 • Piccolo umanoide malvagio, spesso trovato in gruppi.',
          description: 'I goblin sono creature piccole, nere di cuore ed egoiste che vivono nelle caverne, nelle miniere abbandonate, nei dungeon o in accampamenti ben nascosti in superficie. La loro natura li spinge ad attaccare i più deboli e fuggire dai più forti.',
          metaInfo: 'Sfida 1/4 (50 PE)',
        );
      } else {
        return item.copyWith(
          name: 'Goblin',
          shortDescription: 'GS 1/4 • Small, black-hearted, selfish humanoid.',
          description: 'Goblins are small, black-hearted, selfish creatures that live in caves, abandoned mines, or dungeons. Their nature prompts them to attack the weak and flee from the strong.',
          metaInfo: 'GS 1/4 (50 XP)',
        );
      }
    }

    if (item.id == 'ancient_red_dragon' || item.id == 'm2') {
      if (isIt) {
        return item.copyWith(
          name: 'Drago Rosso Antico',
          shortDescription: 'Sfida 24 • Gargantuesco drago cromatico, caotico malvagio.',
          description: 'L\'odore di zolfo e pomice circonda i draghi rossi. Sono i più avidi di tutti i veri draghi, e si annidano sempre vicino ai loro immensi tesori. Esalano un potentissimo cono di fuoco in grado di incenerire interi eserciti.',
          metaInfo: 'Sfida 24 (62.000 PE)',
        );
      } else {
        return item.copyWith(
          name: 'Ancient Red Dragon',
          shortDescription: 'GS 24 • Gargantuan chromatic dragon, chaotic evil.',
          description: 'The odor of sulfur and pumice surrounds red dragons. They are the most covetous of all true dragons, nesting near their immense hoards. They breathe a powerful cone of fire capable of incinerating armies.',
          metaInfo: 'GS 24 (62,000 XP)',
        );
      }
    }

    // Return as-is if it's a synced database monster (which is already loaded from Render API)
    return item;
  }
}
