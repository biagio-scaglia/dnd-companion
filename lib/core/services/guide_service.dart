import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class GuideService {
  static const String _hasSeenGuideKey = 'has_seen_guide';

  static Future<bool> hasSeenGuide() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenGuideKey) ?? false;
  }

  static Future<void> markGuideAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenGuideKey, true);
  }

  static void showGuide({
    required BuildContext context,
    required List<GlobalKey> keys,
  }) {
    // Keys order: [Home, Compendium, Notes, Settings, Map]
    if (keys.length < 5) return;

    final loc = AppLocalizations.of(context)!;
    
    final targets = [
      _createTargetFocus(
        keyTarget: keys[0],
        title: loc.guideTitleHome,
        description: loc.guideDescHome,
        align: ContentAlign.top,
      ),
      _createTargetFocus(
        keyTarget: keys[1],
        title: loc.guideTitleCompendium,
        description: loc.guideDescCompendium,
        align: ContentAlign.top,
      ),
      _createTargetFocus(
        keyTarget: keys[2],
        title: loc.guideTitleChronicles,
        description: loc.guideDescChronicles,
        align: ContentAlign.top,
      ),
      _createTargetFocus(
        keyTarget: keys[3],
        title: loc.guideTitleSettings,
        description: loc.guideDescSettings,
        align: ContentAlign.top,
      ),
      _createTargetFocus(
        keyTarget: keys[4],
        title: loc.guideTitleMaps,
        description: loc.guideDescMaps,
        align: ContentAlign.top,
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: AppColors.surface,
      textSkip: loc.skip,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        markGuideAsSeen();
      },
      onClickTarget: (target) {
        // Optional: Do something when target is clicked
      },
      onSkip: () {
        markGuideAsSeen();
        return true;
      },
    ).show(context: context);
  }

  static TargetFocus _createTargetFocus({
    required GlobalKey keyTarget,
    required String title,
    required String description,
    ContentAlign align = ContentAlign.bottom,
  }) {
    return TargetFocus(
      identify: title,
      keyTarget: keyTarget,
      alignSkip: Alignment.topRight,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.magicAccent, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.magicAccent,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.0,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
