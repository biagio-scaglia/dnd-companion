import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/attachment_section.dart';
import '../../../presentation/widgets/dnd_list_input.dart';
import '../domain/models/session.dart';
import 'notes_controller.dart';

class SessionEditView extends StatefulWidget {
  final CampaignSession? session;
  const SessionEditView({super.key, this.session});

  @override
  State<SessionEditView> createState() => _SessionEditViewState();
}

class _SessionEditViewState extends State<SessionEditView> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  late String _sessionId;

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _sessionId = widget.session!.id;
      _titleController.text = widget.session!.title;
      _numberController.text = widget.session!.number?.toString() ?? '';
      _campaignController.text = widget.session!.campaign ?? '';
      _realDate = widget.session!.realDate;
      _inGameDateController.text = widget.session!.inGameDate ?? '';
      _locationController.text = widget.session!.location ?? '';
      _shortRecapController.text = widget.session!.shortRecap;
      _lootController.text = widget.session!.loot ?? '';
      _notesController.text = widget.session!.notes ?? '';
      _status = widget.session!.status;
      _isImportant = widget.session!.isImportant;
      _isPinned = widget.session!.isPinned;
      
      _mainEvents.addAll(widget.session!.mainEvents);
      _metNpcs.addAll(widget.session!.metNpcs);
      _visitedLocations.addAll(widget.session!.visitedLocations);
      _completedObjectives.addAll(widget.session!.completedObjectives);
      _openObjectives.addAll(widget.session!.openObjectives);
      _tags.addAll(widget.session!.tags);
    } else {
      _sessionId = _uuid.v4();
    }
  }

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
    final notesController = Provider.of<NotesController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session != null ? AppLocalizations.of(context)!.editSession : AppLocalizations.of(context)!.newSession),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.magicAccent),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final session = CampaignSession(
                  id: _sessionId,
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
                  createdAt: widget.session?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                if (widget.session != null) {
                  await notesController.updateSession(session);
                } else {
                  await notesController.createSession(session);
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
            DndSectionHeader(title: AppLocalizations.of(context)!.essentialData),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.sessionTitle,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterTitle : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _numberController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.sessionNumber,
                      labelStyle: const TextStyle(color: AppColors.textSecondary),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.realDate, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.status,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
              ),
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              items: SessionStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status == SessionStatus.bozza ? AppLocalizations.of(context)!.draft : (status == SessionStatus.completata ? AppLocalizations.of(context)!.completed : AppLocalizations.of(context)!.archived)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.important, style: const TextStyle(color: AppColors.textPrimary)),
                Switch(
                  value: _isImportant,
                  onChanged: (val) => setState(() => _isImportant = val),
                  activeColor: AppColors.magicAccent,
                ),
                const Spacer(),
                Text(AppLocalizations.of(context)!.pinned, style: const TextStyle(color: AppColors.textPrimary)),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.shortRecap,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                alignLabelWithHint: true,
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterShortRecap : null,
            ),
            const SizedBox(height: 24),
            
            // Sezioni Espandibili
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.campaignDetails, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                TextFormField(
                  controller: _campaignController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.campaign, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _inGameDateController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.inGameDate, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.inGameLocation, labelStyle: const TextStyle(color: AppColors.textSecondary)),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            ExpansionTile(
              title: Text(AppLocalizations.of(context)!.listsAndContents, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              textColor: AppColors.magicAccent,
              iconColor: AppColors.magicAccent,
              collapsedTextColor: AppColors.textSecondary,
              collapsedIconColor: AppColors.textSecondary,
              children: [
                DndListInput(
                  label: AppLocalizations.of(context)!.mainEvents,
                  controller: _eventInputController,
                  list: _mainEvents,
                  onAdd: () => _addToList(_mainEvents, _eventInputController),
                  onRemove: (index) => _removeFromList(_mainEvents, index),
                ),
                DndListInput(
                  label: AppLocalizations.of(context)!.metNpcs,
                  controller: _npcInputController,
                  list: _metNpcs,
                  onAdd: () => _addToList(_metNpcs, _npcInputController),
                  onRemove: (index) => _removeFromList(_metNpcs, index),
                ),
                DndListInput(
                  label: AppLocalizations.of(context)!.visitedLocations,
                  controller: _locationInputController,
                  list: _visitedLocations,
                  onAdd: () => _addToList(_visitedLocations, _locationInputController),
                  onRemove: (index) => _removeFromList(_visitedLocations, index),
                ),
                DndListInput(
                  label: AppLocalizations.of(context)!.completedObjectives,
                  controller: _compObjectiveInputController,
                  list: _completedObjectives,
                  onAdd: () => _addToList(_completedObjectives, _compObjectiveInputController),
                  onRemove: (index) => _removeFromList(_completedObjectives, index),
                ),
                DndListInput(
                  label: AppLocalizations.of(context)!.openObjectives,
                  controller: _openObjectiveInputController,
                  list: _openObjectives,
                  onAdd: () => _addToList(_openObjectives, _openObjectiveInputController),
                  onRemove: (index) => _removeFromList(_openObjectives, index),
                ),
                DndListInput(
                  label: AppLocalizations.of(context)!.tags,
                  controller: _tagInputController,
                  list: _tags,
                  onAdd: () => _addToList(_tags, _tagInputController),
                  onRemove: (index) => _removeFromList(_tags, index),
                ),
                const SizedBox(height: 16),
              ],
            ),
            
            const SizedBox(height: 24),
            DndSectionHeader(title: AppLocalizations.of(context)!.notesAndLoot),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lootController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.lootRewards,
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
              maxLines: 6,
            ),
            const SizedBox(height: 24),
            AttachmentSection(
              linkedEntityId: _sessionId,
              linkedEntityType: 'session',
              attachments: notesController.attachments,
              onAdd: () => notesController.pickAndAddAttachment(
                linkedEntityId: _sessionId,
                linkedEntityType: 'session',
              ),
              onDelete: (attachment) async {
                await notesController.deleteAttachment(attachment.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.attachmentDeleted, style: const TextStyle(color: AppColors.textPrimary)),
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
