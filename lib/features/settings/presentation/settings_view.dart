import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../presentation/widgets/dnd_loading_indicator.dart';
import '../../../presentation/widgets/dnd_card.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impostazioni')),
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
                        color: AppColors.magicAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.magicAccent.withOpacity(0.25),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.magicAccent,
                        size: 36,
                      ),
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
              DndCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMAZIONI',
                      style: AppTypography.sectionLabel(color: AppColors.highlight),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    _infoRow(Icons.info_outline_rounded, 'App', 'D&D Companion'),
                    const Divider(height: 24),
                    _infoRow(Icons.tag_rounded, 'Build', '1'),
                    const Divider(height: 24),
                    _infoRow(Icons.storage_rounded, 'Dati', 'Salvati localmente'),
                    const Divider(height: 24),
                    _infoRow(Icons.wifi_off_rounded, 'Modalità', 'Offline-first'),
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
}
