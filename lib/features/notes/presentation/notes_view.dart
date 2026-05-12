import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../presentation/widgets/dnd_card.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/dnd_empty_state.dart';
import '../../../presentation/widgets/dnd_text_field.dart';
import 'notes_controller.dart';
import '../domain/models/note.dart';
import 'widgets/note_card.dart';
import 'widgets/character_card.dart';
import 'widgets/session_card.dart';
import 'widgets/attachment_card.dart';
import 'widgets/note_dialogs.dart';
import 'note_edit_view.dart';
import 'session_edit_view.dart';
import 'character_edit_view.dart';
import '../domain/models/character.dart';


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

          final sortedNotes = List<Note>.from(notesController.notes)
            ..sort((a, b) {
              if (a.isImportant != b.isImportant) {
                return a.isImportant ? -1 : 1;
              }
              return b.date.compareTo(a.date);
            });

          return CustomScrollView(
            key: const PageStorageKey('notes_list'),
            slivers: [
              // ── Personaggi ───────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: DndSectionHeader(
                    title: 'I Tuoi Personaggi',
                    accentColor: AppColors.highlight,
                    trailing: IconButton(
                      icon: const Icon(Icons.add_rounded, color: AppColors.highlight, size: 20),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CharacterEditView()),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ),

              if (notesController.characters.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: DndEmptyState(
                      icon: Icons.person_outline_rounded,
                      message: 'Nessun personaggio',
                      subMessage: 'Aggiungi il tuo primo eroe',
                      actionLabel: 'Crea Eroe',
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CharacterEditView()),
                      ),
                      accentColor: AppColors.highlight,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final c = notesController.characters[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: CharacterCard(
                            character: c,
                            onDelete: () => notesController.deleteCharacter(c.id),
                          ),
                        );
                      },
                      childCount: notesController.characters.length,
                    ),
                  ),
                ),

              // ── Sessioni ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: DndSectionHeader(
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
                ),
              ),

              if (notesController.sessions.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: DndEmptyState(
                      icon: Icons.menu_book_outlined,
                      message: 'Nessuna sessione',
                      subMessage: 'Inizia a documentare le tue avventure',
                      actionLabel: 'Nuova Sessione',
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SessionEditView()),
                      ),
                      accentColor: AppColors.magicAccent,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final s = notesController.sessions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SessionCard(
                            session: s,
                            onDelete: () => notesController.deleteSession(s.id),
                          ),
                        );
                      },
                      childCount: notesController.sessions.length,
                    ),
                  ),
                ),

              // ── Appunti ──────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: DndSectionHeader(
                    title: 'Appunti Recenti',
                    accentColor: AppColors.naturalAccent,
                  ),
                ),
              ),

              if (notesController.notes.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: DndEmptyState(
                      icon: Icons.note_outlined,
                      message: 'Nessun appunto',
                      subMessage: 'Inizia a scrivere le tue cronache',
                      actionLabel: 'Scrivi Appunto',
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NoteEditView()),
                      ),
                      accentColor: AppColors.naturalAccent,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final n = sortedNotes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NoteCard(
                            note: n,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => NoteEditView(note: n)),
                            ),
                          ),
                        );
                      },
                      childCount: sortedNotes.length,
                    ),
                  ),
                ),

              // ── Allegati ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: DndSectionHeader(
                    title: 'Allegati',
                    accentColor: AppColors.textSecondary,
                    trailing: IconButton(
                      icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary, size: 20),
                      onPressed: () => notesController.pickAndAddAttachment(
                        linkedEntityId: 'global',
                        linkedEntityType: 'global',
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ),

              if (notesController.attachments.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: DndEmptyState(
                      icon: Icons.attach_file_outlined,
                      message: 'Nessun allegato',
                      accentColor: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final a = notesController.attachments[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AttachmentCard(
                            attachment: a,
                            onDelete: () => notesController.deleteAttachment(a.id),
                          ),
                        );
                      },
                      childCount: notesController.attachments.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl),
              ),
            ],
          );
        },
      ),
    );
  }
}

