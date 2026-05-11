import 'package:flutter/material.dart';
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
      title: 'Nuovo Personaggio',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DndTextField(controller: nameCtrl, label: 'Nome'),
          const SizedBox(height: 12),
          DndTextField(controller: classCtrl, label: 'Classe'),
          const SizedBox(height: 12),
          DndTextField(
            controller: levelCtrl,
            label: 'Livello',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
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
                  race: 'Sconosciuta',
                  status: CharacterStatus.attivo,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Crea', style: TextStyle(color: AppColors.magicAccent)),
        ),
      ],
    ),
  );
}

// Rimossa showAddAttachmentDialog perché obsoleta.
