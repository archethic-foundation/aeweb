/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:math';

import 'package:flutter/material.dart';

part 'archethic_theme_base.dart';

class AeWebThemeBase {
  static String mainFont = 'Telegraf';
  static String addressFont = 'Roboto';

  static Color primaryColor = ArchethicThemeBase.purple500;
  static Color backgroundColor = ArchethicThemeBase.neutral900;
  static Color maxButtonColor = ArchethicThemeBase.raspberry500;
  static Color backgroundPopupColor = ArchethicThemeBase.purple500;

  static Color statusOK = ArchethicThemeBase.systemPositive500;
  static Color statusKO = ArchethicThemeBase.systemDanger800;
  static Color statusInProgress = ArchethicThemeBase.raspberry300;

  static Gradient gradient = LinearGradient(
    colors: [
      ArchethicThemeBase.neutral0.withValues(alpha: 0.2),
      ArchethicThemeBase.neutral0.withValues(alpha: 0),
    ],
    stops: const [0, 1],
  );

  static Gradient gradientMainScreen = const LinearGradient(
    colors: [
      Color(0xFFCC00FF),
      Color(0x003C89B9),
    ],
    stops: [0, 1],
  );

  static Gradient gradientWelcomeTxt = LinearGradient(
    colors: [
      const Color(0xFF562FED).withValues(alpha: 0.8),
      const Color(0xFFD55CFF).withValues(alpha: 0.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient gradientBtn = LinearGradient(
    colors: <Color>[
      ArchethicThemeBase.blue500,
      ArchethicThemeBase.raspberry300,
    ],
    transform: const GradientRotation(pi / 9),
  );

  static Gradient gradientSheetBackground = LinearGradient(
    colors: [
      ArchethicThemeBase.purple500.withValues(alpha: 1),
      ArchethicThemeBase.purple500.withValues(alpha: 1),
    ],
    stops: const [0, 1],
    begin: Alignment.topLeft,
    end: Alignment.center,
  );

  static Gradient gradientSheetBorder = LinearGradient(
    colors: [
      ArchethicThemeBase.neutral900.withValues(alpha: 0.7),
      ArchethicThemeBase.neutral900.withValues(alpha: 1),
    ],
    stops: const [0, 1],
  );

  static Gradient gradientInputFormBackground = LinearGradient(
    colors: [
      ArchethicThemeBase.neutral900.withValues(alpha: 1),
      ArchethicThemeBase.neutral900.withValues(alpha: 0.3),
    ],
    stops: const [0, 1],
  );

  static Gradient gradientInfoBannerBackground = LinearGradient(
    colors: [
      ArchethicThemeBase.neutral900.withValues(alpha: 1),
      ArchethicThemeBase.neutral900.withValues(alpha: 0.3),
    ],
    stops: const [0, 1],
  );

  static Gradient gradientCircularStepProgressIndicator = LinearGradient(
    colors: [
      statusInProgress,
      ArchethicThemeBase.systemWarning800,
    ],
    stops: const [0, 1],
  );

  static Gradient gradientCircularStepProgressIndicatorFinished =
      LinearGradient(
    colors: [
      statusOK,
      ArchethicThemeBase.systemPositive800,
    ],
    stops: const [0, 1],
  );

  static Gradient gradientCircularStepProgressIndicatorError = LinearGradient(
    colors: [
      ArchethicThemeBase.systemDanger800,
      statusKO,
    ],
    stops: const [0, 1],
  );

  static const sizeBoxComponentWidth = 600.0;
}
