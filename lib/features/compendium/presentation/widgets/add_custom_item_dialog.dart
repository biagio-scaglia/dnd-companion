import 'package:flutter/material.dart';
import '../../domain/models/compendium_item.dart';

class AddCustomItemDialog extends StatefulWidget {
  const AddCustomItemDialog({super.key});

  @override
  State<AddCustomItemDialog> createState() => _AddCustomItemDialogState();
}

class _AddCustomItemDialogState extends State<AddCustomItemDialog> {
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  CompendiumItemType _type = CompendiumItemType.item;
  String _shortDesc = '';
  String _desc = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aggiungi Elemento'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (val) => val == null || val.isEmpty ? 'Campo obbligatorio' : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CompendiumItemType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: const [
                  DropdownMenuItem(value: CompendiumItemType.item, child: Text('Oggetto')),
                  DropdownMenuItem(value: CompendiumItemType.monster, child: Text('Mostro')),
                  DropdownMenuItem(value: CompendiumItemType.spell, child: Text('Incantesimo')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Breve Descrizione'),
                validator: (val) => val == null || val.isEmpty ? 'Campo obbligatorio' : null,
                onSaved: (val) => _shortDesc = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrizione Completa'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Campo obbligatorio' : null,
                onSaved: (val) => _desc = val!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              
              final newItem = CompendiumItem(
                id: '', // Sarà generato dal repository
                name: _name,
                type: _type,
                shortDescription: _shortDesc,
                description: _desc,
                metaInfo: 'Homebrew',
                isCustom: true,
              );
              
              Navigator.of(context).pop(newItem);
            }
          },
          child: const Text('Salva'),
        ),
      ],
    );
  }
}
