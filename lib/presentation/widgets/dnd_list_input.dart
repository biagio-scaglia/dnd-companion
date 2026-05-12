import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import 'dnd_chip.dart';

class DndListInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> list;
  final VoidCallback onAdd;
  final Function(int) onRemove;

  const DndListInput({
    super.key,
    required this.label,
    required this.controller,
    required this.list,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: '${AppLocalizations.of(context)!.add}...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.magicAccent),
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: list.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return DndChip(
              label: value,
              accentColor: AppColors.highlight,
              isSelected: false,
              onTap: () => onRemove(index),
            );
          }).toList(),
        ),
      ],
    );
  }
}
