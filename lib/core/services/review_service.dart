import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Servizio per la gestione delle valutazioni dell'applicazione (In-App Review).
/// Supporta trigger basati su momenti positivi d'uso ed evita lo spam.
///
/// Service for managing application ratings (In-App Review).
/// Supports triggers based on positive moments of use and prevents spam.
class ReviewService {
  static const String _eventCountKey = 'review_positive_events_count';
  static const String _hasRequestedReviewKey = 'review_requested_flag';
  
  // Soglia di eventi positivi per mostrare il prompt automatico
  // Threshold of positive events to show the automatic prompt
  static const int _eventThreshold = 5;

  /// Incrementa il contatore degli eventi positivi.
  /// Se viene raggiunta la soglia, attiva la richiesta automatica.
  ///
  /// Increments the positive events counter.
  /// If the threshold is met, triggers the automatic review request.
  static Future<void> incrementPositiveEvents(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Se abbiamo già mostrato il prompt, non facciamo nulla
    // If we have already shown the prompt, do nothing
    final hasRequested = prefs.getBool(_hasRequestedReviewKey) ?? false;
    if (hasRequested) return;

    int currentCount = prefs.getInt(_eventCountKey) ?? 0;
    currentCount++;
    await prefs.setInt(_eventCountKey, currentCount);

    if (currentCount >= _eventThreshold) {
      // Eseguiamo il prompt automatico nel post-frame per evitare conflitti con la UI
      // We run the automatic prompt post-frame to avoid UI conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        requestReviewAutomatically(context);
      });
    }
  }

  /// Mostra la richiesta di recensione automatica (non invasiva, una sola volta).
  ///
  /// Shows the automatic review request (non-intrusive, only once).
  static Future<void> requestReviewAutomatically(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasRequested = prefs.getBool(_hasRequestedReviewKey) ?? false;
    if (hasRequested) return;

    final InAppReview inAppReview = InAppReview.instance;
    
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await prefs.setBool(_hasRequestedReviewKey, true);
      }
    } catch (e) {
      debugPrint('⚠️ [ReviewService] Error during automatic review request: $e');
    }
  }

  /// Avvia la richiesta di recensione manualmente (es. dalle Impostazioni).
  /// Se il sistema in-app non è disponibile, reindirizza allo Store.
  ///
  /// Launches the review request manually (e.g. from Settings).
  /// If the in-app system is unavailable, redirects to the Store.
  static Future<void> requestReviewManually() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        // Salviamo comunque che l'utente ha interagito per recensire
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_hasRequestedReviewKey, true);
      } else {
        await _openStoreFallback();
      }
    } catch (e) {
      debugPrint('⚠️ [ReviewService] Error during manual review request: $e');
      await _openStoreFallback();
    }
  }

  /// Fallback sul browser/store se le API in-app falliscono o non sono supportate.
  ///
  /// Fallback to browser/store if in-app APIs fail or are unsupported.
  static Future<void> _openStoreFallback() async {
    final Uri storeUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.biagioscaglia.vellum',
    );
    try {
      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('⚠️ [ReviewService] Error opening store fallback: $e');
    }
  }
}
