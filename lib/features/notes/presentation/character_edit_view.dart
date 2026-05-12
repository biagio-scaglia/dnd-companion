import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
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
        title: Text(widget.character != null ? 'Modifica Personaggio' : 'Nuovo Personaggio'),
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

                if (widget.character != null) {
                  await notesController.updateCharacter(character);
                } else {
                  await notesController.createCharacter(character);
                }
                
                if (mounted) Navigator.pop(context);
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
            const DndSectionHeader(title: 'Identità'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Personaggio *',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un nome' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _raceController,
                    decoration: const InputDecoration(labelText: 'Razza / Specie *', labelStyle: TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? 'Inserisci la razza' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _classController,
                    decoration: const InputDecoration(labelText: 'Classe *', labelStyle: TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? 'Inserisci la classe' : null,
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
                    decoration: const InputDecoration(labelText: 'Sottoclasse', labelStyle: TextStyle(color: AppColors.textSecondary)),
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(labelText: 'Livello *', labelStyle: TextStyle(color: AppColors.textSecondary)),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    validator: (value) => value == null || value.isEmpty ? 'Inserisci il livello' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CharacterStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Stato *',
                labelStyle: TextStyle(color: AppColors.textSecondary),
              ),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              items: CharacterStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status == CharacterStatus.attivo ? 'Attivo' : (status == CharacterStatus.morto ? 'Morto' : (status == CharacterStatus.ritirato ? 'Ritirato' : 'Alleato NPC'))),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 24),
            
            // Sezioni Espandibili
            ExpansionTile(
              title: const Text('Dati Campagna e Ruolo', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _playerNameController,
                  decoration: const InputDecoration(labelText: 'Nome Giocatore', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _alignmentController,
                  decoration: const InputDecoration(labelText: 'Allineamento', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _backgroundController,
                  decoration: const InputDecoration(labelText: 'Background', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _campaignController,
                  decoration: const InputDecoration(labelText: 'Campagna', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Luogo Attuale', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _goalController,
                  decoration: const InputDecoration(labelText: 'Obiettivo', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            ExpansionTile(
              title: const Text('Tratti e Background Narrativo', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _traitsController,
                  decoration: const InputDecoration(labelText: 'Tratti di Personalità', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _idealsController,
                  decoration: const InputDecoration(labelText: 'Ideali', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bondsController,
                  decoration: const InputDecoration(labelText: 'Legami', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _flawsController,
                  decoration: const InputDecoration(labelText: 'Difetti', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            const SizedBox(height: 24),
            const DndSectionHeader(title: 'Descrizione e Note'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione Breve',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Note Libere',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
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
                await notesController.deleteAttachment(attachment.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Allegato eliminato', style: TextStyle(color: AppColors.textPrimary)),
                      backgroundColor: AppColors.surfaceSecondary,
                      duration: Duration(seconds: 2),
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
