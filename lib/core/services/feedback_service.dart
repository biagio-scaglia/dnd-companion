import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dnd/l10n/app_localizations.dart';

/// Servizio per la gestione e l'invio di segnalazioni bug e feedback tramite email.
/// Raccoglie informazioni di sistema per facilitare il debug.
///
/// Service for managing and sending bug reports and feedback via email.
/// Collects system details to assist with debugging.
class FeedbackService {
  
  /// Genera e lancia l'app di posta con un'email precompilata.
  ///
  /// Generates and launches the mail app with a pre-filled email template.
  static Future<void> sendFeedbackEmail(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    
    // Raccoglie metadati di sistema minimi
    // Gathers minimal system metadata
    String osVersion = 'Web';
    String device = 'Browser';

    if (!kIsWeb) {
      osVersion = Platform.operatingSystemVersion;
      device = Platform.operatingSystem.toUpperCase();
    }

    final String subject = loc.feedbackSubject;
    final String body = loc.feedbackBody(osVersion, device);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@biagioscaglia.com', // Email di riferimento per il supporto / Support email
      query: _encodeQueryParameters({
        'subject': subject,
        'body': body,
      }),
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // Caso di fallback (es. emulatore senza mail app installata)
        // Fallback case (e.g. emulator without a mail client installed)
        if (context.mounted) {
          final isIt = loc.localeName == 'it';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isIt
                    ? 'Impossibile aprire il client email. Invia a: support@biagioscaglia.com'
                    : 'Could not open email client. Please mail: support@biagioscaglia.com',
              ),
              backgroundColor: Colors.amber[800],
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('⚠️ [FeedbackService] Error launching email: $e');
    }
  }

  /// Utility per codificare correttamente i parametri di query (esclude la codifica di spazi in '+' anziché '%20')
  ///
  /// Utility to properly encode query parameters (avoids encoding spaces as '+' instead of '%20')
  static String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
