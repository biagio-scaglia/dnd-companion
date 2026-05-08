import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../presentation/widgets/dnd_card.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import 'notes_controller.dart';
import 'calendar_controller.dart';
import 'widgets/note_card.dart';
import 'widgets/calendar_event_card.dart';
import 'note_edit_view.dart';
import 'session_edit_view.dart';
import '../domain/models/character.dart';
import '../../../core/utils/file_opener/file_opener.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appunti e Sessioni', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NoteEditView()),
              );
            },
          ),
        ],
      ),
      body: Consumer2<NotesController, CalendarController>(
        builder: (context, notesController, calendarController, child) {
          if (notesController.isLoading || calendarController.isLoading) {
            return const DndLoadingIndicator(message: 'Caricamento appunti...');
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Personaggi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'I Tuoi Personaggi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final nameController = TextEditingController();
                          final classController = TextEditingController();
                          final levelController = TextEditingController();
                          return AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: const Text('Nuovo Personaggio', style: TextStyle(color: AppColors.textPrimary)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                TextFormField(
                                  controller: classController,
                                  decoration: const InputDecoration(labelText: 'Classe', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                TextFormField(
                                  controller: levelController,
                                  decoration: const InputDecoration(labelText: 'Livello', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (nameController.text.isNotEmpty) {
                                    notesController.createCharacter(
                                      nameController.text,
                                      classController.text,
                                      int.tryParse(levelController.text) ?? 1,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Crea', style: TextStyle(color: AppColors.magicAccent)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (notesController.characters.isEmpty)
                const Text('Nessun personaggio creato.', style: TextStyle(color: AppColors.textSecondary))
              else
                ...notesController.characters.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DndCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.person_rounded, color: AppColors.highlight, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('${c.characterClass} • Livello ${c.level}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                          onPressed: () => notesController.deleteCharacter(c.id),
                        ),
                      ],
                    ),
                  ),
                )),
                
              const SizedBox(height: 32),
              
              // Sessioni
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sessioni',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SessionEditView()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (notesController.sessions.isEmpty)
                const Text('Nessuna sessione registrata.', style: TextStyle(color: AppColors.textSecondary))
              else
                ...notesController.sessions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DndCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, color: AppColors.magicAccent, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(s.summary, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                          onPressed: () => notesController.deleteSession(s.id),
                        ),
                      ],
                    ),
                  ),
                )),
                
              const SizedBox(height: 32),
              
              // Appunti
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Appunti Recenti',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Vedi tutti', style: TextStyle(color: AppColors.highlight)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (notesController.notes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Nessun appunto creato.', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...notesController.notes.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: NoteCard(
                    note: n, 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NoteEditView(note: n)),
                      );
                    }
                  ),
                )),
                
              const SizedBox(height: 32),
              
              // Allegati
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Allegati Recenti',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textPrimary),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final nameController = TextEditingController();
                          final pathController = TextEditingController();
                          final typeController = TextEditingController();
                          return AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: const Text('Aggiungi Riferimento File', style: TextStyle(color: AppColors.textPrimary)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(labelText: 'Nome File', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                TextFormField(
                                  controller: pathController,
                                  decoration: const InputDecoration(labelText: 'Percorso o URL', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                                TextFormField(
                                  controller: typeController,
                                  decoration: const InputDecoration(labelText: 'Tipo (es. pdf, png)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                                  style: const TextStyle(color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (nameController.text.isNotEmpty && pathController.text.isNotEmpty) {
                                    notesController.addAttachmentReference(
                                      nameController.text,
                                      pathController.text,
                                      typeController.text.isEmpty ? 'file' : typeController.text,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Aggiungi', style: TextStyle(color: AppColors.magicAccent)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 12),
              if (notesController.attachments.isEmpty)
                const Text('Nessun allegato.', style: TextStyle(color: AppColors.textSecondary))
              else
                ...notesController.attachments.map((a) => ListTile(
                  leading: const Icon(Icons.insert_drive_file_rounded, color: AppColors.naturalAccent),
                  title: Text(a.fileName, style: const TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text(a.type.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  onTap: () => openFile(a.filePath),
                )),
            ],
          );
        },
      ),
    );
  }
}
