import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../presentation/widgets/dnd_card.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../../presentation/widgets/dnd_section_title.dart';
import '../../../presentation/widgets/dnd_empty_state.dart';
import '../../../presentation/widgets/dnd_text_field.dart';
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
        title: const Text('Appunti e Sessioni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoteEditView()),
            ),
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
              // ── Personaggi ───────────────────────────────────────────
              DndSectionTitle(
                title: 'I Tuoi Personaggi',
                accentColor: AppColors.highlight,
                trailing: IconButton(
                  icon: const Icon(Icons.add_rounded, color: AppColors.highlight, size: 20),
                  onPressed: () => _showCreateCharacterDialog(context, notesController),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              if (notesController.characters.isEmpty)
                DndEmptyState(
                  icon: Icons.person_outline_rounded,
                  message: 'Nessun personaggio',
                  subMessage: 'Aggiungi il tuo primo eroe',
                  accentColor: AppColors.highlight,
                )
              else
                ...notesController.characters.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DndCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.highlight.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: AppColors.highlight, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: AppTypography.h3),
                              const SizedBox(height: 2),
                              Text(
                                '${c.characterClass} • Liv. ${c.level}',
                                style: AppTypography.bodySmall,
                              ),
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

              const SizedBox(height: AppSpacing.xl),

              // ── Sessioni ─────────────────────────────────────────────
              DndSectionTitle(
                title: 'Sessioni',
                accentColor: AppColors.magicAccent,
                trailing: IconButton(
                  icon: const Icon(Icons.add_rounded, color: AppColors.magicAccent, size: 20),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SessionEditView()),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              if (notesController.sessions.isEmpty)
                DndEmptyState(
                  icon: Icons.menu_book_outlined,
                  message: 'Nessuna sessione',
                  subMessage: 'Inizia a documentare le tue avventure',
                  accentColor: AppColors.magicAccent,
                )
              else
                ...notesController.sessions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DndCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.magicAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu_book_rounded, color: AppColors.magicAccent, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.title, style: AppTypography.h3),
                              const SizedBox(height: 2),
                              Text(s.summary, style: AppTypography.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
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

              const SizedBox(height: AppSpacing.xl),

              // ── Appunti ──────────────────────────────────────────────
              DndSectionTitle(
                title: 'Appunti Recenti',
                accentColor: AppColors.naturalAccent,
              ),
              const SizedBox(height: AppSpacing.m),

              if (notesController.notes.isEmpty)
                DndEmptyState(
                  icon: Icons.note_outlined,
                  message: 'Nessun appunto',
                  subMessage: 'Tocca il + in alto per creare il primo appunto',
                  accentColor: AppColors.naturalAccent,
                )
              else
                ...notesController.notes.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NoteCard(
                    note: n,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NoteEditView(note: n)),
                    ),
                  ),
                )),
              const SizedBox(height: AppSpacing.xl),

              // ── Allegati ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ALLEGATI',
                    style: AppTypography.sectionLabel(color: AppColors.textSecondary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary, size: 20),
                    onPressed: () => notesController.pickAttachment(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),

              if (notesController.attachments.isEmpty)
                const DndEmptyState(
                  icon: Icons.attach_file_outlined,
                  message: 'Nessun allegato',
                  accentColor: AppColors.textSecondary,
                )
              else
                ...notesController.attachments.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DndCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insert_drive_file_rounded, color: AppColors.naturalAccent, size: 22),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.fileName, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                                  Text(a.type.toUpperCase(), style: AppTypography.caption),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 18),
                              onPressed: () => notesController.deleteAttachment(a.id),
                            ),
                          ],
                        ),
                        if (a.type == 'image') ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(a.filePath),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: AppColors.surfaceSecondary,
                                  child: const Center(
                                    child: Icon(Icons.broken_image_rounded, color: AppColors.textSecondary),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),

              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }

  void _showCreateCharacterDialog(BuildContext context, NotesController controller) {
    final nameCtrl = TextEditingController();
    final classCtrl = TextEditingController();
    final levelCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuovo Personaggio'),
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
            child: Text('Crea', style: TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }

  void _showAddAttachmentDialog(BuildContext context, NotesController controller) {
    final nameCtrl = TextEditingController();
    final pathCtrl = TextEditingController();
    final typeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aggiungi Riferimento File'),
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
            child: Text('Aggiungi', style: TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }
}
