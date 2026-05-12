import 'package:flutter/material.dart';
import 'package:dnd/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.addItem),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: l10n.name),
                validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                onSaved: (val) => _name = val!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CompendiumItemType>(
                value: _type,
                decoration: InputDecoration(labelText: l10n.category),
                items: [
                  DropdownMenuItem(value: CompendiumItemType.item, child: Text(l10n.item)),
                  DropdownMenuItem(value: CompendiumItemType.monster, child: Text(l10n.monster)),
                  DropdownMenuItem(value: CompendiumItemType.spell, child: Text(l10n.spell)),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _type = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: l10n.shortDescription),
                validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                onSaved: (val) => _shortDesc = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: l10n.fullDescription),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                onSaved: (val) => _desc = val!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
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
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
