import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/attachment_section.dart';
import '../domain/models/character.dart';
import 'notes_controller.dart';

class CharacterEditView extends StatefulWidget {
  final Character? character;
  const CharacterEditView({super.key, this.character});

  @override
  State<CharacterEditView> createState() => _CharacterEditViewState();
}

class _CharacterEditViewState extends State<CharacterEditView> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  late String _characterId;

  @override
  void initState() {
    super.initState();
    if (widget.character != null) {
      _characterId = widget.character!.id;
      _nameController.text = widget.character!.name;
      _playerNameController.text = widget.character!.playerName ?? '';
      _raceController.text = widget.character!.race;
      _classController.text = widget.character!.characterClass;
      _subclassController.text = widget.character!.subclass ?? '';
      _levelController.text = widget.character!.level.toString();
      _alignmentController.text = widget.character!.alignment ?? '';
      _backgroundController.text = widget.character!.background ?? '';
      _campaignController.text = widget.character!.campaign ?? '';
      _locationController.text = widget.character!.currentLocation ?? '';
      _goalController.text = widget.character!.goal ?? '';
      _traitsController.text = widget.character!.traits ?? '';
      _idealsController.text = widget.character!.ideals ?? '';
      _bondsController.text = widget.character!.bonds ?? '';
      _flawsController.text = widget.character!.flaws ?? '';
      _shortDescriptionController.text = widget.character!.shortDescription ?? '';
      _notesController.text = widget.character!.notes ?? '';
      _status = widget.character!.status;
    } else {
      _characterId = _uuid.v4();
    }
  }

  // Controllers
  final _nameController = TextEditingController();
  final _playerNameController = TextEditingController();
  final _raceController = TextEditingController();
  final _classController = TextEditingController();
  final _subclassController = TextEditingController();
  final _levelController = TextEditingController();
  final _alignmentController = TextEditingController();
  final _backgroundController = TextEditingController();
  final _campaignController = TextEditingController();
  final _locationController = TextEditingController();
  final _goalController = TextEditingController();
  final _traitsController = TextEditingController();
  final _idealsController = TextEditingController();
  final _bondsController = TextEditingController();
  final _flawsController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _notesController = TextEditingController();

  // State
  CharacterStatus _status = CharacterStatus.attivo;

  @override
  void dispose() {
    _nameController.dispose();
    _playerNameController.dispose();
    _raceController.dispose();
    _classController.dispose();
    _subclassController.dispose();
    _levelController.dispose();
    _alignmentController.dispose();
    _backgroundController.dispose();
    _campaignController.dispose();
    _locationController.dispose();
    _goalController.dispose();
    _traitsController.dispose();
    _idealsController.dispose();
    _bondsController.dispose();
    _flawsController.dispose();
    _shortDescriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character != null ? AppLocalizations.of(context)!.editCharacter : AppLocalizations.of(context)!.newCharacter),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.magicAccent),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final character = Character(
                  id: _characterId,
                  name: _nameController.text,
                  playerName: _playerNameController.text.isNotEmpty ? _playerNameController.text : null,
                  race: _raceController.text,
                  characterClass: _classController.text,
                  subclass: _subclassController.text.isNotEmpty ? _subclassController.text : null,
                  level: int.tryParse(_levelController.text) ?? 1,
                  alignment: _alignmentController.text.isNotEmpty ? _alignmentController.text : null,
                  background: _backgroundController.text.isNotEmpty ? _backgroundController.text : null,
                  status: _status,
                  campaign: _campaignController.text.isNotEmpty ? _campaignController.text : null,
                  currentLocation: _locationController.text.isNotEmpty ? _locationController.text : null,
                  goal: _goalController.text.isNotEmpty ? _goalController.text : null,
                  traits: _traitsController.text.isNotEmpty ? _traitsController.text : null,
                  ideals: _idealsController.text.isNotEmpty ? _idealsController.text : null,
                  bonds: _bondsController.text.isNotEmpty ? _bondsController.text : null,
                  flaws: _flawsController.text.isNotEmpty ? _flawsController.text : null,
                  shortDescription: _shortDescriptionController.text.isNotEmpty ? _shortDescriptionController.text : null,
                  notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                  createdAt: widget.character?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final navigator = Navigator.of(context);
                if (widget.character != null) {
                  await notesController.updateCharacter(character);
                } else {
                  await notesController.createCharacter(character);
                }
                
                if (mounted) navigator.pop();
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            DndSectionHeader(title: AppLocalizations.of(context)!.identity),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.characterName,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterName : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _raceController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.raceSpecies, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterRace : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _classController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.classLabel, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterClass : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _subclassController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.subclassLabel, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: InputDecoration(labelText: AppLocalizations.of(context)!.levelLabel, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterLevel : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CharacterStatus>(
              initialValue: _status,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.statusLabel,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
              ),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              items: CharacterStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status == CharacterStatus.attivo ? AppLocalizations.of(context)!.active : (status == CharacterStatus.morto ? AppLocalizations.of(context)!.dead : (status == CharacterStatus.ritirato ? AppLocalizations.of(context)!.retired : AppLocalizations.of(context)!.npcAlly))),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 24),
            
            // Sezioni Espandibili
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.campaignRoleData, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _playerNameController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.playerName, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _alignmentController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.alignment, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _backgroundController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.background, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _campaignController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.campaign, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.currentLocation, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _goalController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.goal, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.traitsNarrative, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _traitsController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.personalityTraits, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _idealsController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.ideals, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bondsController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.bonds, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _flawsController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.flaws, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            const SizedBox(height: 24),
            DndSectionHeader(title: AppLocalizations.of(context)!.descriptionNotes),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortDescriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shortDescription,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.freeNotes,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            AttachmentSection(
              linkedEntityId: _characterId,
              linkedEntityType: 'character',
              attachments: notesController.attachments,
              onAdd: () => notesController.pickAndAddAttachment(
                linkedEntityId: _characterId,
                linkedEntityType: 'character',
              ),
              onDelete: (attachment) async {
                final messenger = ScaffoldMessenger.of(context);
                final l10n = AppLocalizations.of(context)!;
                await notesController.deleteAttachment(attachment.id);
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(l10n.attachmentDeleted, style: const TextStyle(color: AppColors.textPrimary)),
                      backgroundColor: AppColors.surfaceSecondary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
