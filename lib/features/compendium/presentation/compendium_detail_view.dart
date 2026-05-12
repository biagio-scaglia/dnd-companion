import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _fetchDetailsIfNeeded();
  }

  Future<void> _fetchDetailsIfNeeded() async {
    // Controlla se la descrizione è quella generica e non è un item custom
    if (!_item.isCustom && _item.description.contains('Dettagli non disponibili')) {
      setState(() => _isLoadingDesc = true);
      try {
        final client = DndApiClient();
        final desc = await client.fetchItemDescription(_item.type, _item.id);
        
        setState(() {
          _item = _item.copyWith(description: desc);
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

    switch (_item.type) {
      case CompendiumItemType.monster:
        imagePath = 'lib/assets/icone/Monster Part/Skull.png';
        typeColor = AppColors.danger;
        break;
      case CompendiumItemType.spell:
        imagePath = 'lib/assets/icone/Misc/Scroll.png';
        typeColor = AppColors.magicAccent;
        break;
      case CompendiumItemType.item:
        imagePath = 'lib/assets/icone/Equipment/Iron Armor.png';
        typeColor = AppColors.highlight;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio'),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: imagePath != null
                      ? Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.contain)
                      : Icon(Icons.help_outline_rounded, color: typeColor, size: 32),
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
                            _item.metaInfo!,
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
            const Text(
              'Descrizione',
              style: TextStyle(
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
                _item.description,
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
