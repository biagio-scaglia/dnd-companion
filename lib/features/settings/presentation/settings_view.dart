import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.information)),
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.magicAccent.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.magicAccent.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'lib/assets/logo/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text('Vellum', style: AppTypography.h1),
                    const SizedBox(height: 4),
                    Text('Versione 1.0.0', style: AppTypography.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Lingua
              DndSectionHeader(
                title: l10n.language,
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Image.asset('lib/assets/icone/Misc/Scroll.png', width: 18, height: 18),
                    const SizedBox(width: 12),
                    Text(l10n.languageApp, style: AppTypography.bodySmall),
                    const Spacer(),
                    DropdownButton<String>(
                      value: controller.settings.locale,
                      dropdownColor: AppColors.surface,
                      style: AppTypography.body,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'it',
                          child: Text('Italiano'),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.setLocale(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              // Informazioni
              DndSectionHeader(
                title: l10n.information,
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(null, l10n.app, 'Vellum', imagePath: 'lib/assets/icone/Misc/Book.png'),
                    const Divider(height: 24),
                    _infoRow(Icons.tag_rounded, l10n.build, '1'),
                    const Divider(height: 24),
                    _infoRow(null, l10n.data, l10n.savedLocally, imagePath: 'lib/assets/icone/Misc/Chest.png'),
                    const Divider(height: 24),
                    _infoRow(Icons.wifi_off_rounded, l10n.mode, l10n.offlineFirst),
                    const Divider(height: 24),
                    _infoRow(null, 'API', 'D&D 5e API', imagePath: 'lib/assets/icone/Misc/Scroll.png'),
                    const Divider(height: 24),
                    _infoRow(Icons.palette_outlined, 'Icone', 'Cainos (itch.io)'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              DndSectionHeader(
                title: l10n.legal,
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _actionRow(context, null, l10n.privacyPolicy, () {
                      _showPolicyDialog(context, l10n.privacyPolicy, l10n.privacyPolicyContent);
                    }, imagePath: 'lib/assets/icone/Misc/Scroll.png'),
                    const Divider(height: 24),
                    _actionRow(context, null, l10n.cookiePolicy, () {
                      _showPolicyDialog(context, l10n.cookiePolicy, l10n.cookiePolicyContent);
                    }, imagePath: 'lib/assets/icone/Misc/Book 3.png'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              
              DndSectionHeader(
                title: l10n.backupRestore,
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
                          _actionRow(context, null, l10n.exportData, () {
                            backupController.exportBackup();
                          }, imagePath: 'lib/assets/icone/Misc/Chest.png'),
                          const Divider(height: 24),
                           _actionRow(context, null, l10n.restoreData, () async {
                            await backupController.pickAndPreviewBackup();
                            if (backupController.preview != null) {
                              _showImportOptionsDialog(context, backupController);
                            }
                          }, imagePath: 'lib/assets/icone/Misc/Crate.png'),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.m),
              DndSectionHeader(
                title: l10n.permissions,
                accentColor: AppColors.highlight,
              ),
              const SizedBox(height: AppSpacing.s),
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _actionRow(context, Icons.settings_applications_rounded, l10n.managePermissions, () async {
                      await openAppSettings();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              Center(
                child: Text(
                  l10n.createdForAdventurers,
                  style: AppTypography.caption,
                ),
              ),  ),
            ],
          );
        },
      ),
    );
  }

  Widget _actionRow(BuildContext context, IconData? icon, String label, VoidCallback onTap, {String? imagePath}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            if (imagePath != null)
              Image.asset(imagePath, width: 18, height: 18)
            else
              Icon(icon!, color: AppColors.textSecondary, size: 18),
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

  Widget _infoRow(IconData? icon, String label, String value, {String? imagePath}) {
    return Row(
      children: [
        if (imagePath != null)
          Image.asset(imagePath, width: 18, height: 18)
        else
          Icon(icon!, color: AppColors.textSecondary, size: 18),
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
