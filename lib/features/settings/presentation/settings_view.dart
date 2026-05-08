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
              // Informazioni App
              SettingsSectionCard(
                title: 'Informazioni App',
                children: [
                  const SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'D&D Companion',
                    subtitle: 'Versione 1.0.0 (Build 1)\nUn\'app per gestire le tue campagne di D&D.',
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
