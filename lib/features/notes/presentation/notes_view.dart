import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../presentation/widgets/dnd_card.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/dnd_empty_state.dart';
import '../../../presentation/widgets/dnd_error_state.dart';
import '../../../presentation/widgets/dnd_motion.dart';
import 'notes_controller.dart';
import '../domain/models/note.dart';
import 'widgets/note_card.dart';
import 'widgets/character_card.dart';
import 'widgets/session_card.dart';
import 'widgets/attachment_card.dart';
import 'note_edit_view.dart';
import 'session_edit_view.dart';
import 'character_edit_view.dart';


class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appuntiESessioni),
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
              message: AppLocalizations.of(context)!.ritualFailed,
              subMessage: AppLocalizations.of(context)!.dataRetrieveError,
              actionLabel: AppLocalizations.of(context)!.retryRitual,
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

          final globalAttachments = notesController.attachments.where((a) => a.linkedEntityId == 'global').toList();

          return CustomScrollView(
            key: const PageStorageKey('notes_list'),
            slivers: [
              // ── Personaggi ───────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: DndSectionHeader(
                    title: AppLocalizations.of(context)!.yourCharacters,
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
                      message: AppLocalizations.of(context)!.noHero,
                      subMessage: AppLocalizations.of(context)!.emptyCharacters,
                      actionLabel: AppLocalizations.of(context)!.generateHero,
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
                            onDeleteAttachment: (attachmentId) => notesController.deleteAttachment(attachmentId),
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
                    title: AppLocalizations.of(context)!.sessionsTitle,
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
                      message: AppLocalizations.of(context)!.noChapter,
                      subMessage: AppLocalizations.of(context)!.emptySessions,
                      actionLabel: AppLocalizations.of(context)!.writeChapter,
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
                            onDeleteAttachment: (attachmentId) => notesController.deleteAttachment(attachmentId),
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
                    title: AppLocalizations.of(context)!.recentNotes,
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
                      message: AppLocalizations.of(context)!.noMemory,
                      subMessage: AppLocalizations.of(context)!.emptyNotes,
                      actionLabel: AppLocalizations.of(context)!.transcribe,
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
                            onDeleteAttachment: (attachmentId) => notesController.deleteAttachment(attachmentId),
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
                    title: AppLocalizations.of(context)!.attachments,
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

                if (globalAttachments.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: DndEmptyState(
                        imagePath: 'lib/assets/icone/Misc/Chest.png',
                        message: AppLocalizations.of(context)!.noArtifact,
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
                          final a = globalAttachments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AttachmentCard(
                              attachment: a,
                              onDelete: () => notesController.deleteAttachment(a.id),
                            ),
                          );
                        },
                        childCount: globalAttachments.length,
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

