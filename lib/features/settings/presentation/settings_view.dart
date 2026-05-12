import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../presentation/widgets/dnd_card.dart';
import '../../../presentation/widgets/dnd_mystic_icon_circle.dart';
import '../../../presentation/widgets/dnd_section_header.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../backup/presentation/backup_controller.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Consumer<SettingsController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const DndLoadingIndicator(message: 'Caricamento...');
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              // Hero section
              Center(
                child: Column(
                  children: [
                    const DndMysticIconCircle(
                      icon: Icons.auto_awesome_rounded,
                      accentColor: AppColors.magicAccent,
                      size: 80,
                      showGlow: true,
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text('D&D Companion', style: AppTypography.h1),
                    const SizedBox(height: 4),
                    Text('Versione 1.0.0', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Informazioni
              const DndSectionHeader(
                title: 'Informazioni',
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(Icons.info_outline_rounded, 'App', 'D&D Companion'),
                    const Divider(height: 24),
                    _infoRow(Icons.tag_rounded, 'Build', '1'),
                    const Divider(height: 24),
                    _infoRow(Icons.storage_rounded, 'Dati', 'Salvati localmente'),
                    const Divider(height: 24),
                    _infoRow(Icons.wifi_off_rounded, 'Modalità', 'Offline-first'),
                    const Divider(height: 24),
                    _infoRow(Icons.public_rounded, 'API', 'D&D 5e API'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              const DndSectionHeader(
                title: 'Legale',
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _actionRow(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {
                      _showPolicyDialog(context, 'Privacy Policy', 'Questa applicazione rispetta la tua privacy. Tutti i dati inseriti (note, mappe, personaggi) vengono salvati esclusivamente in locale sul tuo dispositivo e non vengono inviati a nessun server esterno.\n\nL\'app non raccoglie dati personali, non richiede registrazione e non traccia le tue attività.\n\nI permessi richiesti (come l\'accesso alla memoria) servono solo per consentirti di salvare le mappe come immagini o allegare file alle tue note.');
                    }),
                    const Divider(height: 24),
                    _actionRow(context, Icons.cookie_outlined, 'Cookie Policy', () {
                      _showPolicyDialog(context, 'Cookie Policy', 'Questa applicazione è sviluppata in Flutter ed è pensata principalmente come app mobile.\n\nNon utilizza cookie di tracciamento, cookie di terze parti o cookie di profilazione.\n\nSe utilizzata su piattaforma Web, potrebbero essere utilizzati solo cookie tecnici strettamente necessari per il funzionamento dell\'interfaccia (come il mantenimento dello stato o delle preferenze locali tramite LocalStorage), che non profilano l\'utente in alcun modo.');
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              
              // Backup e Ripristino
              const DndSectionHeader(
                title: 'Backup e Ripristino',
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              Consumer<BackupController>(
                builder: (context, backupController, child) {
                  // Ascolta i risultati per mostrare feedback
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (backupController.lastResult != null) {
                      final result = backupController.lastResult!;
                      backupController.clearLastResult();
                      
                      String msg = result.message;
                      if (result.mergeDetails != null) {
                        final d = result.mergeDetails!;
                        msg += '\n(Ignorati: ${d['ignored']}, Duplicati: ${d['duplicated']})';
                      }
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                          backgroundColor: result.success ? AppColors.naturalAccent : AppColors.danger,
                        ),
                      );
                    }
                  });

                  return DndCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (backupController.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(color: AppColors.magicAccent),
                            ),
                          )
                        else ...[
                          _actionRow(context, Icons.cloud_upload_outlined, 'Esporta Dati (.dndc)', () {
                            backupController.exportBackup();
                          }),
                          const Divider(height: 24),
                          _actionRow(context, Icons.cloud_download_outlined, 'Ripristina Dati (.dndc)', () async {
                            await backupController.pickAndPreviewBackup();
                            if (backupController.preview != null) {
                              _showImportOptionsDialog(context, backupController);
                            }
                          }),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),
              const DndSectionHeader(
                title: 'Permessi',
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _actionRow(context, Icons.settings_applications_rounded, 'Gestisci Permessi App', () async {
                      await openAppSettings();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Center(
                child: Text(
                  'Creato per veri avventurieri ⚔️',
                  style: AppTypography.caption,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _actionRow(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(width: 12),
            Text(label, style: AppTypography.bodySmall),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: AppTypography.h3),
        content: SingleChildScrollView(
          child: Text(content, style: AppTypography.body),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi', style: TextStyle(color: AppColors.magicAccent)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.bodySmall),
        const Spacer(),
        Text(value, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showImportOptionsDialog(BuildContext context, BackupController controller) {
    final preview = controller.preview!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Rituale di Ripristino', style: AppTypography.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trovati nel file:', style: AppTypography.body),
            const SizedBox(height: 8),
            Text('• ${preview.characterCount} Personaggi', style: AppTypography.bodySmall),
            Text('• ${preview.sessionCount} Sessioni', style: AppTypography.bodySmall),
            Text('• ${preview.noteCount} Note', style: AppTypography.bodySmall),
            Text('• ${preview.attachmentCount} Allegati', style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            const Text('Scegli come procedere:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.executeImport(overwrite: false);
            },
            child: const Text('Unisci', style: TextStyle(color: AppColors.magicAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showConfirmOverwriteDialog(context, controller);
            },
            child: const Text('Sovrascrivi', style: TextStyle(color: AppColors.danger)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showConfirmOverwriteDialog(BuildContext context, BackupController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Attenzione!', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
        content: const Text('Questa operazione CANCELLERÀ tutti i dati attuali dell\'app e li sostituirà con quelli del backup. Sei sicuro?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.executeImport(overwrite: true);
            },
            child: const Text('Sì, Sovrascrivi', style: TextStyle(color: AppColors.danger)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
