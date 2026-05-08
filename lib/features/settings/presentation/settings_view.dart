import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import 'settings_controller.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/settings_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SettingsController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.magicAccent));
          }

          final settings = controller.settings;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Aspetto
              SettingsSectionCard(
                title: 'Aspetto',
                children: [
                  SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'Tema Scuro',
                    subtitle: 'Mantieni l\'app in modalità scura',
                    trailing: Switch(
                      value: settings.darkTheme,
                      onChanged: (val) => controller.toggleDarkTheme(val),
                      activeColor: AppColors.magicAccent,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.palette_rounded,
                    title: 'Colore Accento',
                    subtitle: 'Scegli il colore dominante',
                    trailing: DropdownButton<String>(
                      value: settings.accentColor,
                      dropdownColor: AppColors.surface,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'magic', child: Text('Viola Magico', style: TextStyle(fontSize: 14))),
                        DropdownMenuItem(value: 'nature', child: Text('Verde Natura', style: TextStyle(fontSize: 14))),
                        DropdownMenuItem(value: 'highlight', child: Text('Oro', style: TextStyle(fontSize: 14))),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.setAccentColor(val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Comportamento
              SettingsSectionCard(
                title: 'Comportamento',
                children: [
                  SettingsTile(
                    icon: Icons.animation_rounded,
                    title: 'Animazioni',
                    subtitle: 'Abilita transizioni ed effetti visivi',
                    trailing: Switch(
                      value: settings.animationsEnabled,
                      onChanged: (val) => controller.toggleAnimations(val),
                      activeColor: AppColors.magicAccent,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.vibration_rounded,
                    title: 'Feedback Aptico',
                    subtitle: 'Vibrazione al tocco se supportata',
                    trailing: Switch(
                      value: settings.hapticFeedback,
                      onChanged: (val) => controller.toggleHaptic(val),
                      activeColor: AppColors.magicAccent,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.view_compact_rounded,
                    title: 'Modalità Compatta',
                    subtitle: 'Riduci le spaziature per mostrare più contenuti',
                    trailing: Switch(
                      value: settings.compactMode,
                      onChanged: (val) => controller.toggleCompactMode(val),
                      activeColor: AppColors.magicAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dati e Archivio
              SettingsSectionCard(
                title: 'Dati e Archivio',
                children: [
                  SettingsTile(
                    icon: Icons.backup_rounded,
                    title: 'Backup Locale',
                    subtitle: 'Salva una copia dei dati sul dispositivo',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup completato (simulato)')),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.upload_file_rounded,
                    title: 'Esporta Dati',
                    subtitle: 'Esporta in formato JSON',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Esportazione completata (simulato)')),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.download_rounded,
                    title: 'Importa Dati',
                    subtitle: 'Carica dati da un file salvato',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Importazione completata (simulato)')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Privacy
              SettingsSectionCard(
                title: 'Privacy',
                children: [
                  const SettingsTile(
                    icon: Icons.security_rounded,
                    title: 'Dati Locali',
                    subtitle: 'Tutti i tuoi dati sono salvati esclusivamente sul tuo dispositivo. Nessun dato viene inviato a server esterni.',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Informazioni App
              SettingsSectionCard(
                title: 'Informazioni App',
                children: [
                  const SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'D&D Companion',
                    subtitle: 'Versione 1.0.0 (Build 1)\nUn\'app per gestire le tue campagne di D&D.',
                  ),
                  SettingsTile(
                    icon: Icons.code_rounded,
                    title: 'GitHub',
                    subtitle: 'Visualizza il codice sorgente',
                    onTap: () {
                      // Azione simulata
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Azioni Avanzate
              SettingsSectionCard(
                title: 'Azioni Avanzate',
                children: [
                  SettingsTile(
                    icon: Icons.restore_rounded,
                    title: 'Ripristina Impostazioni',
                    subtitle: 'Riporta le impostazioni ai valori di default',
                    isDestructive: true,
                    onTap: () {
                      // Azione simulata
                    },
                  ),
                  SettingsTile(
                    icon: Icons.delete_forever_rounded,
                    title: 'Cancella Tutti i Dati',
                    subtitle: 'Azione irreversibile! Cancella note e personaggi.',
                    isDestructive: true,
                    onTap: () {
                      // Azione simulata
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
