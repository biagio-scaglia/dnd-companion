import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/dnd_card.dart';
import '../../../features/compendium/domain/models/compendium_item.dart';
import '../../../features/compendium/domain/models/compendium_filter.dart';
import '../../../features/compendium/presentation/compendium_detail_view.dart';
import '../../../features/compendium/data/repositories/compendium_repository_impl.dart';
import '../../../features/compendium/data/datasources/daily_monster_helper.dart';

class CompendiumPreviewWidget extends StatefulWidget {
  const CompendiumPreviewWidget({super.key});

  @override
  State<CompendiumPreviewWidget> createState() => _CompendiumPreviewWidgetState();
}

class _CompendiumPreviewWidgetState extends State<CompendiumPreviewWidget> {
  late Future<CompendiumItem> _dailyMonsterFuture;
  final _repository = CompendiumRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _dailyMonsterFuture = _loadDailyMonster();
  }

  Future<CompendiumItem> _loadDailyMonster() async {
    try {
      final monsters = await _repository.fetchItems(
        const CompendiumFilter(selectedCategory: CompendiumItemType.monster),
      );
      return DailyMonsterHelper.getDailyMonster(monsters);
    } catch (e) {
      debugPrint('Errore caricamento mostro del giorno: $e');
      return DailyMonsterHelper.getDailyMonster(const []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultMonster = DailyMonsterHelper.getDailyMonster(const []);
    final localizedDefault = DailyMonsterHelper.getLocalizedItem(context, defaultMonster);

    return FutureBuilder<CompendiumItem>(
      future: _dailyMonsterFuture,
      initialData: localizedDefault,
      builder: (context, snapshot) {
        final rawMonster = snapshot.data ?? localizedDefault;
        final monster = DailyMonsterHelper.getLocalizedItem(context, rawMonster);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CompendiumDetailView(item: monster)),
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
                      Text(monster.name, style: AppTypography.h2),
                      const SizedBox(height: 2),
                      Text(
                        monster.shortDescription,
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
      },
    );
  }
}
