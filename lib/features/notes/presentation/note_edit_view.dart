import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/attachment_section.dart';
import '../domain/models/note.dart';
import 'notes_controller.dart';

class NoteEditView extends StatefulWidget {
  final Note? note;

  const NoteEditView({super.key, this.note});

  @override
  State<NoteEditView> createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  bool _isImportant = false;
  String? _selectedSessionId;

  late String _noteId;

  @override
  void initState() {
    super.initState();
    _noteId = widget.note?.id ?? const Uuid().v4();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _tagsController = TextEditingController(text: widget.note?.tags.join(', ') ?? '');
    _isImportant = widget.note?.isImportant ?? false;
    _selectedSessionId = widget.note?.sessionId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(context);
    final sessions = notesController.sessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? AppLocalizations.of(context)!.newNote : AppLocalizations.of(context)!.editNote),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.magicAccent),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final tags = _tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final navigator = Navigator.of(context);

                if (widget.note == null) {
                  final note = Note(
                    id: _noteId,
                    title: _titleController.text,
                    content: _contentController.text,
                    date: DateTime.now(),
                    isImportant: _isImportant,
                    sessionId: _selectedSessionId,
                    tags: tags,
                  );
                  await notesController.repository.addNote(note);
                  await notesController.loadData();
                } else {
                  final updatedNote = widget.note!.copyWith(
                    title: _titleController.text,
                    content: _contentController.text,
                    isImportant: _isImportant,
                    sessionId: _selectedSessionId,
                    tags: tags,
                  );
                  // Supponendo di aggiungere un metodo updateNote nel controller
                  // Per ora usiamo il repository direttamente o aggiungiamo il metodo
                  await notesController.repository.updateNote(updatedNote);
                  await notesController.loadData();
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
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.title,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.surfaceSecondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.magicAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterTitle : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.content,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.surfaceSecondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.magicAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 10,
              minLines: 5,
              validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context)!.enterContent : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.tagsComma,
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.surfaceSecondary),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.magicAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.markAsImportant, style: const TextStyle(color: AppColors.textPrimary)),
              value: _isImportant,
              onChanged: (bool value) {
                setState(() {
                  _isImportant = value;
                });
              },
              activeThumbColor: AppColors.magicAccent,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.linkToSession, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedSessionId != null && sessions.any((s) => s.id == _selectedSessionId) ? _selectedSessionId : null,
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text(AppLocalizations.of(context)!.noSession),
                ),
                ...sessions.map((session) => DropdownMenuItem<String>(
                      value: session.id,
                      child: Text(session.title),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSessionId = value;
                });
              },
            ),
            const SizedBox(height: 24),
            AttachmentSection(
              linkedEntityId: _noteId,
              linkedEntityType: 'note',
              attachments: notesController.attachments,
              onAdd: () => notesController.pickAndAddAttachment(
                linkedEntityId: _noteId,
                linkedEntityType: 'note',
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
            const SizedBox(height: 40),
            if (widget.note != null) ...[
              TextButton.icon(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  await notesController.deleteNote(widget.note!.id);
                  if (mounted) navigator.pop();
                },
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
                label: Text(AppLocalizations.of(context)!.deleteNote, style: const TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
