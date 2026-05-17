import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../presentation/widgets/dnd_card.dart';
import '../../../../presentation/widgets/dnd_button.dart';
import '../../domain/models/map_tile_type.dart';
import '../controllers/map_editor_controller.dart';

class TilePalette extends StatelessWidget {
  const TilePalette({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapEditorController>();
    
    return DndCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.tile.toUpperCase(),
            style: AppTypography.label.copyWith(color: AppColors.highlight),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showTilePicker(context, controller),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.surfaceSecondary),
              ),
              child: Row(
                children: [
                  if (controller.selectedTileType != MapTileType.emoji) ...[
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getColorForType(controller.selectedTileType),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: controller.selectedTileType.isSolid 
                        ? Center(child: Container(width: 4, height: 4, color: Colors.black45))
                        : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getTileName(context, controller.selectedTileType).toUpperCase(),
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.category_rounded, size: 24, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.selectTile,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                  const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceSecondary),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.iconsAndEmoji.toUpperCase(),
            style: AppTypography.label.copyWith(color: AppColors.magicAccent),
          ),
          const SizedBox(height: 12),
          DndButton(
            text: AppLocalizations.of(context)!.browseIcons,
            onPressed: () => _showIconPicker(context, controller),
            backgroundColor: AppColors.surfaceSecondary,
            foregroundColor: AppColors.textPrimary,
            isSmall: true,
          ),
          const SizedBox(height: 8),
          // Mostra l'icona/emoji corrente selezionata
          if (controller.selectedTileType == MapTileType.emoji)
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: controller.selectedEmoji.endsWith('.png')
                    ? Image.asset(controller.selectedEmoji, width: 32, height: 32)
                    : Text(controller.selectedEmoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
        ],
      ),
    );
  }

  void _showIconPicker(BuildContext context, MapEditorController controller) {
    final Map<String, List<String>> categories = {
      'equip': [
        'Bag.png', 'Belt.png', 'Helm.png', 'Iron Armor.png', 'Iron Boot.png',
        'Iron Helmet.png', 'Leather Armor.png', 'Leather Boot.png', 'Leather Helmet.png',
        'Wizard Hat.png', 'Wooden Armor.png'
      ].map((e) => 'lib/assets/icone/Equipment/$e').toList(),
      'potions': [
        'Blue Potion 2.png', 'Blue Potion 3.png', 'Blue Potion.png', 'Empty Bottle.png',
        'Green Potion 2.png', 'Green Potion 3.png', 'Green Potion.png', 'Red Potion 2.png',
        'Red Potion 3.png', 'Red Potion.png', 'Water Bottle.png'
      ].map((e) => 'lib/assets/icone/Potion/$e').toList(),
      'weapons': [
        'Arrow.png', 'Axe.png', 'Bow.png', 'Emerald Staff.png', 'Golden Sword.png',
        'Hammer.png', 'Iron Shield.png', 'Iron Sword.png', 'Knife.png', 'Magic Wand.png',
        'Pickaxe.png', 'Ruby Staff.png', 'Sapphire Staff.png', 'Shovel.png', 'Silver Sword.png',
        'Topaz Staff.png', 'Torch.png', 'Wooden Shield.png', 'Wooden Staff.png', 'Wooden Sword.png'
      ].map((e) => 'lib/assets/icone/Weapon & Tool/$e').toList(),
      'food': [
        'Apple.png', 'Beer.png', 'Bread.png', 'Cheese.png', 'Fish Steak.png',
        'Green Apple.png', 'Ham.png', 'Meat.png', 'Mushroom.png', 'Wine 2.png', 'Wine.png'
      ].map((e) => 'lib/assets/icone/Food/$e').toList(),
      'materials': [
        'Fabric.png', 'Leather.png', 'Paper.png', 'Rope.png', 'String.png',
        'Wood Log.png', 'Wooden Plank.png', 'Wool.png'
      ].map((e) => 'lib/assets/icone/Material/$e').toList(),
      'monsters': [
        'Bone.png', 'Egg.png', 'Feather.png', 'Monster Egg.png', 'Monster Eye.png',
        'Monster Meat.png', 'Skull.png', 'Slime Gel.png'
      ].map((e) => 'lib/assets/icone/Monster Part/$e').toList(),
      'gems': [
        'Coal.png', 'Copper Ingot.png', 'Copper Nugget.png', 'Crystal.png',
        'Cut Emerald.png', 'Cut Ruby.png', 'Cut Sapphire.png', 'Cut Topaz.png',
        'Diamond.png', 'Emerald.png', 'Gold Nugget.png', 'Golden Ingot.png',
        'Obsidian.png', 'Pearl.png', 'Ruby.png', 'Sapphire.png', 'Silver Ingot.png',
        'Silver Nugget.png', 'Topaz.png'
      ].map((e) => 'lib/assets/icone/Ore & Gem/$e').toList(),
      'misc': [
        'Book 2.png', 'Book 3.png', 'Book.png', 'Candle.png', 'Chest.png',
        'Copper Coin.png', 'Crate.png', 'Envolop.png', 'Gear.png', 'Golden Coin.png',
        'Golden Key.png', 'Heart.png', 'Iron Key.png', 'Lantern.png', 'Map.png',
        'Rune Stone.png', 'Scroll.png', 'Silver Coin.png', 'Silver Key.png'
      ].map((e) => 'lib/assets/icone/Misc/$e').toList(),
      'emoji': ['🧱', '🪵', '💧', '🔥', '🚪', '📦', '🌲', '🪨', '🏰', '👹', '🧙', '🐉', '💀', '💰'],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColors.magicAccent,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.magicAccent,
                  tabs: categories.keys.map((cat) {
                    switch (cat) {
                      case 'equip': return Tab(text: AppLocalizations.of(context)!.equip);
                      case 'potions': return Tab(text: AppLocalizations.of(context)!.potions);
                      case 'weapons': return Tab(text: AppLocalizations.of(context)!.weapons);
                      case 'food': return Tab(text: AppLocalizations.of(context)!.food);
                      case 'materials': return Tab(text: AppLocalizations.of(context)!.materials);
                      case 'monsters': return Tab(text: AppLocalizations.of(context)!.monsters);
                      case 'gems': return Tab(text: AppLocalizations.of(context)!.gems);
                      case 'misc': return Tab(text: AppLocalizations.of(context)!.misc);
                      case 'emoji': return Tab(text: AppLocalizations.of(context)!.emoji);
                      default: return Tab(text: cat);
                    }
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.values.map((icons) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: icons.length,
                        itemBuilder: (context, index) {
                          final icon = icons[index];
                          final isPng = icon.endsWith('.png');
                          return InkWell(
                            onTap: () {
                              controller.selectEmoji(icon);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: controller.selectedEmoji == icon
                                      ? AppColors.magicAccent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: isPng
                                    ? Image.asset(icon, width: 28, height: 28, fit: BoxFit.contain)
                                    : Text(icon, style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getColorForType(MapTileType type) {
    switch (type) {
      case MapTileType.floorStone: return const Color(0xFF424242);
      case MapTileType.floorWood: return const Color(0xFF5D4037);
      case MapTileType.floorDirt: return const Color(0xFF3E2723);
      case MapTileType.floorGrass: return const Color(0xFF4CAF50);
      case MapTileType.swamp: return const Color(0xFF2E7D32);
      case MapTileType.wallStone: return const Color(0xFF757575);
      case MapTileType.wallWood: return const Color(0xFF795548);
      case MapTileType.water: return const Color(0xFF1976D2);
      case MapTileType.lava: return const Color(0xFFE64A19);
      case MapTileType.doorClosed: return const Color(0xFFFFB300);
      case MapTileType.doorOpen: return const Color(0xFFFFE082);
      case MapTileType.stairsUp:
      case MapTileType.stairsDown: return const Color(0xFFBDBDBD);
      case MapTileType.chest: return AppColors.highlight;
      case MapTileType.table: return const Color(0xFF8D6E63);
      case MapTileType.barrel: return const Color(0xFFA1887F);
      case MapTileType.emoji: return Colors.transparent;
    }
  }

  String _getTileName(BuildContext context, MapTileType type) {
    final loc = AppLocalizations.of(context)!;
    switch (type) {
      case MapTileType.floorStone: return loc.tileFloorStone;
      case MapTileType.floorWood: return loc.tileFloorWood;
      case MapTileType.floorDirt: return loc.tileFloorDirt;
      case MapTileType.floorGrass: return loc.tileFloorGrass;
      case MapTileType.swamp: return loc.tileSwamp;
      case MapTileType.wallStone: return loc.tileWallStone;
      case MapTileType.wallWood: return loc.tileWallWood;
      case MapTileType.water: return loc.tileWater;
      case MapTileType.lava: return loc.tileLava;
      case MapTileType.doorClosed: return loc.tileDoorClosed;
      case MapTileType.doorOpen: return loc.tileDoorOpen;
      case MapTileType.stairsUp: return loc.tileStairsUp;
      case MapTileType.stairsDown: return loc.tileStairsDown;
      case MapTileType.chest: return loc.tileChest;
      case MapTileType.table: return loc.tileTable;
      case MapTileType.barrel: return loc.tileBarrel;
      case MapTileType.emoji: return loc.emoji;
    }
  }

  void _showTilePicker(BuildContext context, MapEditorController controller) {
    final loc = AppLocalizations.of(context)!;
    
    final Map<String, List<MapTileType>> categories = {
      loc.terrain: [
        MapTileType.floorGrass, MapTileType.floorDirt, MapTileType.floorStone, 
        MapTileType.floorWood, MapTileType.swamp, MapTileType.water, MapTileType.lava
      ],
      loc.structures: [
        MapTileType.wallStone, MapTileType.wallWood, MapTileType.doorClosed, 
        MapTileType.doorOpen, MapTileType.stairsUp, MapTileType.stairsDown
      ],
      loc.special: [
        MapTileType.chest, MapTileType.table, MapTileType.barrel
      ],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: DefaultTabController(
            length: categories.length,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  labelColor: AppColors.magicAccent,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.magicAccent,
                  tabs: categories.keys.map((cat) => Tab(text: cat)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: categories.values.map((tiles) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: tiles.length,
                        itemBuilder: (context, index) {
                          final type = tiles[index];
                          final isSelected = controller.selectedTileType == type;
                          return InkWell(
                            onTap: () {
                              controller.selectTool(MapEditorTool.brush);
                              controller.selectTileType(type);
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.magicAccent : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: _getColorForType(type),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: type.isSolid 
                                      ? Center(child: Container(width: 6, height: 6, color: Colors.black45))
                                      : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _getTileName(context, type),
                                    style: AppTypography.caption,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
