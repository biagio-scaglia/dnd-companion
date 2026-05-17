import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:dnd/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/guide_step_widget.dart';

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
    required bool isMobile,
  }) {
    // Keys order: [Home, Compendium, Notes, Settings, Map]
    if (keys.length < 5) return;

    final loc = AppLocalizations.of(context)!;
    final int totalSteps = 5;
    
    // Su mobile i bottoni sono in basso, quindi il tooltip va sopra (top).
    // Su desktop/tablet i bottoni sono a sinistra, quindi il tooltip va a destra (right).
    final ContentAlign align = isMobile ? ContentAlign.top : ContentAlign.right;
    
    final targets = [
      _createTargetFocus(
        keyTarget: keys[0],
        title: loc.guideTitleHome,
        description: loc.guideDescHome,
        align: align,
        currentStep: 1,
        totalSteps: totalSteps,
      ),
      _createTargetFocus(
        keyTarget: keys[1],
        title: loc.guideTitleCompendium,
        description: loc.guideDescCompendium,
        align: align,
        currentStep: 2,
        totalSteps: totalSteps,
      ),
      _createTargetFocus(
        keyTarget: keys[2],
        title: loc.guideTitleChronicles,
        description: loc.guideDescChronicles,
        align: align,
        currentStep: 3,
        totalSteps: totalSteps,
      ),
      _createTargetFocus(
        keyTarget: keys[3],
        title: loc.guideTitleSettings,
        description: loc.guideDescSettings,
        align: align,
        currentStep: 4,
        totalSteps: totalSteps,
      ),
      _createTargetFocus(
        keyTarget: keys[4],
        title: loc.guideTitleMaps,
        description: loc.guideDescMaps,
        align: align,
        currentStep: 5,
        totalSteps: totalSteps,
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
    required ContentAlign align,
    required int currentStep,
    required int totalSteps,
  }) {
    return TargetFocus(
      identify: title,
      keyTarget: keyTarget,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      radius: 12,
      contents: [
        TargetContent(
          align: align,
          customPosition: null, // Lasciamo calcolare a tutorial_coach_mark
          builder: (context, controller) {
            return GuideStepWidget(
              title: title,
              description: description,
              controller: controller,
              currentStep: currentStep,
              totalSteps: totalSteps,
            );
          },
        ),
      ],
    );
  }
}
