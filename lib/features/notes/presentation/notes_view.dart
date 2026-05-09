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
import 'widgets/character_card.dart';
import 'widgets/session_card.dart';
import 'widgets/attachment_card.dart';
import 'widgets/note_dialogs.dart';
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
      body: Consumer<NotesController>(
        builder: (context, notesController, child) {
          if (notesController.isLoading) {
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
                  onPressed: () => showCreateCharacterDialog(context, notesController),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              if (notesController.characters.isEmpty)
                const DndEmptyState(
                  icon: Icons.person_outline_rounded,
                  message: 'Nessun personaggio',
                  subMessage: 'Aggiungi il tuo primo eroe',
                  accentColor: AppColors.highlight,
                )
              else
                ...notesController.characters.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CharacterCard(
                    character: c,
                    onDelete: () => notesController.deleteCharacter(c.id),
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
                const DndEmptyState(
                  icon: Icons.menu_book_outlined,
                  message: 'Nessuna sessione',
                  subMessage: 'Inizia a documentare le tue avventure',
                  accentColor: AppColors.magicAccent,
                )
              else
                ...notesController.sessions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SessionCard(
                    session: s,
                    onDelete: () => notesController.deleteSession(s.id),
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
                const DndEmptyState(
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
                  child: AttachmentCard(
                    attachment: a,
                    onDelete: () => notesController.deleteAttachment(a.id),
                  ),
                )),

              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }
}

