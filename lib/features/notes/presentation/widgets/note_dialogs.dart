import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/widgets/dnd_dialog.dart';
import '../../../../presentation/widgets/dnd_text_field.dart';
import '../notes_controller.dart';
import '../../domain/models/character.dart';
import 'package:uuid/uuid.dart';

void showCreateCharacterDialog(BuildContext context, NotesController controller) {
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final levelCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => DndDialog(
      title: AppLocalizations.of(context)!.newCharacter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DndTextField(controller: nameCtrl, label: AppLocalizations.of(context)!.name),
          const SizedBox(height: 12),
          DndTextField(controller: classCtrl, label: AppLocalizations.of(context)!.classLabel),
          const SizedBox(height: 12),
          DndTextField(
            controller: levelCtrl,
            label: AppLocalizations.of(context)!.level,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            if (nameCtrl.text.isNotEmpty) {
              controller.createCharacter(
                Character(
                  id: const Uuid().v4(),
                  name: nameCtrl.text,
                  characterClass: classCtrl.text,
                  level: int.tryParse(levelCtrl.text) ?? 1,
                  race: AppLocalizations.of(context)!.unknown,
                  status: CharacterStatus.attivo,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text(AppLocalizations.of(context)!.create, style: const TextStyle(color: AppColors.magicAccent)),
        ),
      ],
    ),
  );
}

// Rimossa showAddAttachmentDialog perché obsoleta.
