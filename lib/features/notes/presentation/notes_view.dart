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
import '../../../presentation/widgets/dnd_error_state.dart';
import '../../../presentation/widgets/dnd_motion.dart';
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
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _NoteSkeletonCard(),
                      ),
                      childCount: 5,
                    ),
                  ),
                ),
              ],
            );
          }

          if (notesController.hasError) {
            return DndErrorState(
              message: 'Il rituale di evocazione è fallito',
              subMessage: 'Non siamo riusciti a recuperare i tuoi dati dall\'abisso.',
              actionLabel: 'Riprova il rituale',
              onAction: () => notesController.loadData(),
            );
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
                      imagePath: 'lib/assets/icone/Equipment/Helm.png',
                      message: 'Nessun eroe',
                      subMessage: 'L\'elenco dei personaggi è vuoto.',
                      actionLabel: 'Genera Eroe',
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
                            attachments: notesController.attachments.where((a) => a.linkedEntityId == c.id).toList(),
                            onDelete: () => notesController.deleteCharacter(c.id),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CharacterEditView(character: c)),
                            ),
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
                      imagePath: 'lib/assets/icone/Misc/Book.png',
                      message: 'Nessun capitolo',
                      subMessage: 'Le pagine delle cronache sono vuote.',
                      actionLabel: 'Scrivi Capitolo',
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
                            attachments: notesController.attachments.where((a) => a.linkedEntityId == s.id).toList(),
                            onDelete: () => notesController.deleteSession(s.id),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SessionEditView(session: s)),
                            ),
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
                      imagePath: 'lib/assets/icone/Misc/Scroll.png',
                      message: 'Nessuna memoria',
                      subMessage: 'Le pagine sono ancora bianche.',
                      actionLabel: 'Trascrivi',
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
                            attachments: notesController.attachments.where((a) => a.linkedEntityId == n.id).toList(),
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
                      imagePath: 'lib/assets/icone/Misc/Chest.png',
                      message: 'Nessun reperto',
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

class _NoteSkeletonCard extends StatelessWidget {
  const _NoteSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return DndCard(
      padding: const EdgeInsets.all(16),
      child: DndShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 150,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

