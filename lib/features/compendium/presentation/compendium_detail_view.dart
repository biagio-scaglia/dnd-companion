import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/compendium_item.dart';
import '../data/datasources/dnd_api_client.dart';
import '../../../../core/database/database_helper.dart';

class CompendiumDetailView extends StatefulWidget {
  final CompendiumItem item;

  const CompendiumDetailView({super.key, required this.item});

  @override
  State<CompendiumDetailView> createState() => _CompendiumDetailViewState();
}

class _CompendiumDetailViewState extends State<CompendiumDetailView> {
  late CompendiumItem _item;
  bool _isLoadingDesc = false;

  bool _detailsFetched = false;

  String _translateMetaInfo(BuildContext context, String metaInfo) {
    final l10n = AppLocalizations.of(context)!;
    if (metaInfo.startsWith('Incantesimo')) {
      final school = metaInfo.replaceAll('Incantesimo', '').trim();
      return '${l10n.spell} $school'.trim();
    }
    if (metaInfo == 'Mostro') return l10n.monster;
    if (metaInfo == 'Oggetto') return l10n.item;
    if (metaInfo == 'Classe') return l10n.classes;
    if (metaInfo == 'Razza') return l10n.races;
    return metaInfo;
  }

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_detailsFetched) {
      _fetchDetailsIfNeeded();
      _detailsFetched = true;
    }
  }

  Future<void> _fetchDetailsIfNeeded() async {
    final l10n = AppLocalizations.of(context)!;
    // Controlla se la descrizione è quella generica e non è un item custom
    if (!_item.isCustom && 
        (_item.description.contains(l10n.detailsNotAvailable) || 
         _item.description.contains('__DETAILS_NOT_AVAILABLE_OFFLINE__') ||
         _item.description == '__TAP_TO_LOAD_DETAILS__')) {
      setState(() => _isLoadingDesc = true);
      try {
        final client = DndApiClient();
        final result = await client.fetchItemDescription(_item.type, _item.id);
        
        setState(() {
          _item = _item.copyWith(
            description: result['description'] ?? '',
            shortDescription: result['shortDescription'] ?? _item.shortDescription,
            metaInfo: result['metaInfo'] ?? _item.metaInfo,
          );
          _isLoadingDesc = false;
        });

        // Aggiorna il DB in locale così rimane salvato offline
        DatabaseHelper.instance.updateItem(_item.toMap());
      } catch (e) {
        setState(() {
          _isLoadingDesc = false;
        });
        print('Errore fetch dettaglio: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? imagePath;
    Color typeColor;

    final knownMonsterIcons = ['aberration', 'beast', 'celestial', 'construct', 'dragon', 'elemental', 'fae', 'fiend', 'giant', 'humanoid', 'monstrosity', 'ooze', 'plant', 'undead'];
    final knownSpellIcons = ['abjuration', 'conjuration', 'divination', 'enchantment', 'evocation', 'illusion', 'necromancy', 'transmutation'];
    final knownClassIcons = ['artificer', 'barbarian', 'bard', 'cleric', 'druid', 'fighter', 'monk', 'paladin', 'ranger', 'rogue', 'sorcerer', 'warlock', 'wizard'];

    switch (_item.type) {
      case CompendiumItemType.monster:
        final desc = _item.shortDescription;
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
        final meta = _item.metaInfo ?? '';
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
        if (_item.name.toLowerCase().contains('sword') || 
            _item.name.toLowerCase().contains('blade')) {
          imagePath = 'lib/assets/weapon/sword.svg';
        } else if (_item.name.toLowerCase().contains('dagger')) {
          imagePath = 'lib/assets/weapon/dagger.svg';
        } else if (_item.name.toLowerCase().contains('axe')) {
          imagePath = 'lib/assets/weapon/battleaxe.svg';
        } else if (_item.name.toLowerCase().contains('bow')) {
          imagePath = 'lib/assets/weapon/bow.svg';
        } else if (_item.name.toLowerCase().contains('staff')) {
          imagePath = 'lib/assets/weapon/staff.svg';
        } else {
          imagePath = 'lib/assets/icone/Equipment/Iron Armor.png';
        }
        typeColor = AppColors.highlight;
        break;
      case CompendiumItemType.characterClass:
        if (knownClassIcons.contains(_item.id.toLowerCase())) {
          imagePath = 'lib/assets/class/${_item.id}.svg';
        } else {
          imagePath = null;
        }
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.race:
        imagePath = null;
        typeColor = AppColors.naturalAccent;
        break;
    }

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detail),
        actions: [
          if (_item.isFavorite)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.favorite_rounded, color: AppColors.danger),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF120B07), // Sfondo scuro e profondo
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF5C4033), // Bordo marrone scuro/legno
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imagePath != null
                          ? (imagePath!.endsWith('.svg')
                              ? SvgPicture.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  colorFilter: ColorFilter.mode(typeColor, BlendMode.srcIn),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      _item.type == CompendiumItemType.characterClass ? Icons.book : 
                                      (_item.type == CompendiumItemType.race ? Icons.people : Icons.help_outline_rounded),
                                      color: typeColor, 
                                      size: 32
                                    );
                                  },
                                )
                              : Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                ))
                          : Icon(
                              _item.type == CompendiumItemType.characterClass ? Icons.book : 
                              (_item.type == CompendiumItemType.race ? Icons.people : Icons.help_outline_rounded),
                              color: typeColor, 
                              size: 32
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _item.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_item.metaInfo != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _translateMetaInfo(context, _item.metaInfo!),
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              l10n.description,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoadingDesc)
              const Center(child: CircularProgressIndicator(color: AppColors.highlight))
            else
              Text(
                _item.description == '__TAP_TO_LOAD_DETAILS__'
                    ? AppLocalizations.of(context)!.tapToLoadDetails
                    : (_item.description.startsWith('__DETAILS_NOT_AVAILABLE_OFFLINE__')
                        ? _item.description.replaceFirst('__DETAILS_NOT_AVAILABLE_OFFLINE__', AppLocalizations.of(context)!.detailsNotAvailableOffline)
                        : _item.description),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
