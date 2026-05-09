import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/dnd_accent_pill.dart';
import '../domain/models/session.dart';
import 'notes_controller.dart';

class SessionEditView extends StatefulWidget {
  const SessionEditView({super.key});

  @override
  State<SessionEditView> createState() => _SessionEditViewState();
}

class _SessionEditViewState extends State<SessionEditView> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // Controllers
  final _titleController = TextEditingController();
  final _numberController = TextEditingController();
  final _campaignController = TextEditingController();
  final _inGameDateController = TextEditingController();
  final _locationController = TextEditingController();
  final _shortRecapController = TextEditingController();
  final _lootController = TextEditingController();
  final _notesController = TextEditingController();

  // Lists and state
  DateTime _realDate = DateTime.now();
  SessionStatus _status = SessionStatus.bozza;
  bool _isImportant = false;
  bool _isPinned = false;

  final List<String> _mainEvents = [];
  final List<String> _metNpcs = [];
  final List<String> _visitedLocations = [];
  final List<String> _completedObjectives = [];
  final List<String> _openObjectives = [];
  final List<String> _tags = [];

  // Controllers for adding to lists
  final _eventInputController = TextEditingController();
  final _npcInputController = TextEditingController();
  final _locationInputController = TextEditingController();
  final _compObjectiveInputController = TextEditingController();
  final _openObjectiveInputController = TextEditingController();
  final _tagInputController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _campaignController.dispose();
    _inGameDateController.dispose();
    _locationController.dispose();
    _shortRecapController.dispose();
    _lootController.dispose();
    _notesController.dispose();
    _eventInputController.dispose();
    _npcInputController.dispose();
    _locationInputController.dispose();
    _compObjectiveInputController.dispose();
    _openObjectiveInputController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _realDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.magicAccent,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _realDate) {
      setState(() {
        _realDate = picked;
      });
    }
  }

  void _addToList(List<String> list, TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        list.add(value);
        controller.clear();
      });
    }
  }

  void _removeFromList(List<String> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Sessione'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.magicAccent),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final session = CampaignSession(
                  id: _uuid.v4(),
                  title: _titleController.text,
                  number: _numberController.text.isNotEmpty ? int.tryParse(_numberController.text) : null,
                  campaign: _campaignController.text.isNotEmpty ? _campaignController.text : null,
                  realDate: _realDate,
                  inGameDate: _inGameDateController.text.isNotEmpty ? _inGameDateController.text : null,
                  location: _locationController.text.isNotEmpty ? _locationController.text : null,
                  shortRecap: _shortRecapController.text,
                  mainEvents: _mainEvents,
                  metNpcs: _metNpcs,
                  visitedLocations: _visitedLocations,
                  loot: _lootController.text.isNotEmpty ? _lootController.text : null,
                  completedObjectives: _completedObjectives,
                  openObjectives: _openObjectives,
                  notes: _notesController.text.isNotEmpty ? _notesController.text : null,
                  status: _status,
                  isImportant: _isImportant,
                  isPinned: _isPinned,
                  tags: _tags,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                await notesController.createSession(session);
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
            const DndSectionHeader(title: 'Dati Essenziali'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titolo Sessione *',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un titolo' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _numberController,
                    decoration: const InputDecoration(
                      labelText: 'Numero Sessione',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    title: const Text('Data Reale *', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    subtitle: Text(
                      '${_realDate.day}/${_realDate.month}/${_realDate.year}',
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.calendar_today_rounded, color: AppColors.magicAccent, size: 20),
                    onTap: () => _selectDate(context),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SessionStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Stato',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
              ),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              items: SessionStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status == SessionStatus.bozza ? 'Bozza' : (status == SessionStatus.completata ? 'Completata' : 'Archiviata')),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Importante', style: TextStyle(color: AppColors.textPrimary)),
                Switch(
                  value: _isImportant,
                  onChanged: (val) => setState(() => _isImportant = val),
                  activeColor: AppColors.magicAccent,
                ),
                const Spacer(),
                const Text('Fissato', style: TextStyle(color: AppColors.textPrimary)),
                Switch(
                  value: _isPinned,
                  onChanged: (val) => setState(() => _isPinned = val),
                  activeColor: AppColors.highlight,
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _shortRecapController,
              decoration: const InputDecoration(
                labelText: 'Recap Breve *',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un breve recap' : null,
            ),
            const SizedBox(height: 24),
            
            // Sezioni Espandibili
            ExpansionTile(
              title: const Text('Dettagli Campagna', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _campaignController,
                  decoration: const InputDecoration(labelText: 'Campagna', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _inGameDateController,
                  decoration: const InputDecoration(labelText: 'Data In-Game', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Luogo In-Game', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            ExpansionTile(
              title: const Text('Liste e Contenuti', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                _buildListInput('Eventi Principali', _eventInputController, _mainEvents),
                _buildListInput('NPC Incontrati', _npcInputController, _metNpcs),
                _buildListInput('Luoghi Visitati', _locationInputController, _visitedLocations),
                _buildListInput('Obiettivi Completati', _compObjectiveInputController, _completedObjectives),
                _buildListInput('Obiettivi Aperti', _openObjectiveInputController, _openObjectives),
                _buildListInput('Tag', _tagInputController, _tags),
                const SizedBox(height: 16),
              ],
            ),
            
            const SizedBox(height: 24),
            const DndSectionHeader(title: 'Note e Bottino'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lootController,
              decoration: const InputDecoration(
                labelText: 'Bottino / Ricompense',
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
              maxLines: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListInput(String label, TextEditingController controller, List<String> list) {
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
                decoration: const InputDecoration(
                  hintText: 'Aggiungi...',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.magicAccent),
              onPressed: () => _addToList(list, controller),
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
            return DndAccentPill(
              label: value,
              accentColor: AppColors.highlight,
              isFilled: false,
              onTap: () => _removeFromList(list, index), // Clicca per rimuovere
            );
          }).toList(),
        ),
      ],
    );
  }
}
