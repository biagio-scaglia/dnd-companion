import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../presentation/widgets/dnd_dialog.dart';
import '../../../../presentation/widgets/dnd_text_field.dart';
import '../notes_controller.dart';

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
                nameCtrl.text,
                classCtrl.text,
                int.tryParse(levelCtrl.text) ?? 1,
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

void showAddAttachmentDialog(BuildContext context, NotesController controller) {
  final nameCtrl = TextEditingController();
  final pathCtrl = TextEditingController();
  final typeCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => DndDialog(
      title: 'Aggiungi Riferimento File',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DndTextField(controller: nameCtrl, label: 'Nome File'),
          const SizedBox(height: 12),
          DndTextField(controller: pathCtrl, label: 'Percorso o URL'),
          const SizedBox(height: 12),
          DndTextField(controller: typeCtrl, label: 'Tipo (es. pdf, png)'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            if (nameCtrl.text.isNotEmpty && pathCtrl.text.isNotEmpty) {
              controller.addAttachmentReference(
                nameCtrl.text,
                pathCtrl.text,
                typeCtrl.text.isEmpty ? 'file' : typeCtrl.text,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Aggiungi', style: TextStyle(color: AppColors.magicAccent)),
        ),
      ],
    ),
  );
}
