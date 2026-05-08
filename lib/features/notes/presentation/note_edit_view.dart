import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
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
        title: Text(widget.note == null ? 'Nuova Nota' : 'Modifica Nota'),
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

                if (widget.note == null) {
                  await notesController.createNote(
                    _titleController.text,
                    _contentController.text,
                    isImportant: _isImportant,
                    sessionId: _selectedSessionId,
                    tags: tags,
                  );
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
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titolo',
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
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un titolo' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Contenuto',
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
              validator: (value) => value == null || value.isEmpty ? 'Inserisci il contenuto' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: 'Tag (separati da virgola)',
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
              title: const Text('Contrassegna come importante', style: TextStyle(color: AppColors.textPrimary)),
              value: _isImportant,
              onChanged: (bool value) {
                setState(() {
                  _isImportant = value;
                });
              },
              activeColor: AppColors.magicAccent,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            const Text('Collega a una sessione', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSessionId != null && sessions.any((s) => s.id == _selectedSessionId) ? _selectedSessionId : null,
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Nessuna sessione'),
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
            if (widget.note != null) ...[
              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () async {
                  await notesController.deleteNote(widget.note!.id);
                  if (mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
                label: const Text('Elimina Nota', style: TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
