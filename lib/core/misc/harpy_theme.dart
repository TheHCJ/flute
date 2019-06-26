import 'package:flutter/material.dart';
import 'package:harpy/core/shared_preferences/theme/harpy_theme_data.dart';

class HarpyTheme {
  HarpyTheme.fromData(HarpyThemeData data) {
    name = data.name;
    backgroundColors =
        data.backgroundColors.map((value) => Color(value)).toList();
    primaryColor = Color(data.primaryColor);
    accentColor = Color(data.accentColor);
  }

  String name;

  /// A list of 2 colors that define the background gradient.
  List<Color> backgroundColors;

  /// The primary color should be the same brightness of the background.
  Color primaryColor;

  /// The accent color should compliment the background color.
  Color accentColor;

  /// Gets the brightness by averaging the relative luminance of each
  /// background color.
  ///
  /// Similar to [ThemeData.estimateBrightnessForColor] for multiple colors.
  Brightness get brightness {
    double relativeLuminance = backgroundColors
            .map((color) => color.computeLuminance())
            .reduce((a, b) => a + b) /
        backgroundColors.length;

    const double kThreshold = 0.15;

    return ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) >
            kThreshold)
        ? Brightness.light
        : Brightness.dark;
  }

  /// Returns the [primaryColor] if it is not the same brightness as the button
  /// color, otherwise a complimentary color (white / black).
  Color get buttonTextColor {
    final accentColorBrightness =
        ThemeData.estimateBrightnessForColor(primaryColor);

    if (brightness == Brightness.dark) {
      // button color is light
      return accentColorBrightness == Brightness.light
          ? Colors.black
          : primaryColor;
    } else {
      // button color is dark
      return accentColorBrightness == Brightness.dark
          ? Colors.white
          : primaryColor;
    }
  }

  Color get backgroundComplimentaryColor =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  TextTheme get _textTheme {
    final displayFont = "Comfortaa";
    final bodyFont = "OpenSans";

    final complimentaryColor = backgroundComplimentaryColor;

    return Typography.englishLike2018.apply(fontFamily: bodyFont).copyWith(
          // display
          display4: TextStyle(
            fontSize: 64.0,
            letterSpacing: 6.0,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),
          display3: TextStyle(
            fontSize: 48.0,
            letterSpacing: 2.0,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),
          display2: TextStyle(
            fontFamily: displayFont,
            color: complimentaryColor,
          ),
          display1: TextStyle(
            fontSize: 18.0,
            letterSpacing: 2.0,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor.withOpacity(0.8),
          ),

          // title
          title: TextStyle(
            fontFamily: displayFont,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w300,
            color: complimentaryColor,
          ),

          subhead: TextStyle(
            letterSpacing: 1.0,
            fontFamily: displayFont,
            fontWeight: FontWeight.w300,
            color: complimentaryColor.withOpacity(0.9),
          ),

          // body
          body1: TextStyle(
            fontSize: 16.0,
            fontFamily: bodyFont,
          ),

          body2: TextStyle(
            fontSize: 14.0,
            fontFamily: bodyFont,
            color: complimentaryColor.withOpacity(0.7),
          ),

          button: TextStyle(
            fontSize: 16.0,
            letterSpacing: 1.2,
            fontFamily: bodyFont,
            color: buttonTextColor,
          ),
        );
  }

  ThemeData get theme {
    final complimentaryColor = backgroundComplimentaryColor;

    return ThemeData(
      brightness: brightness,
      textTheme: _textTheme,
      primaryColor: primaryColor,
      accentColor: accentColor,
      buttonColor: complimentaryColor,

      // determines the status bar icon color
      primaryColorBrightness: brightness,

      // used for the background color of Material widgets
      cardColor: primaryColor,
      canvasColor: primaryColor,
    );
  }
}

// todo: define theme data for predefined themes ("crow", "phoenix", "swan")
class PredefinedThemes {
  static List<HarpyTheme> get themes {
    return <HarpyTheme>[
      HarpyTheme.fromData(crow),
      HarpyTheme.fromData(swan),
      HarpyTheme.fromData(phoenix),
    ];
  }

  static HarpyThemeData get crow {
    return HarpyThemeData()
      ..name = "crow"
      ..backgroundColors = [Colors.black.value, 0xff17233d]
      ..primaryColor = 0xff17233d
      ..accentColor = 0xff6b99ff;
  }

  static HarpyThemeData get phoenix {
    return HarpyThemeData()
      ..name = "phoenix"
      ..backgroundColors = [0xffdd2222, Colors.deepOrange.value]
      ..primaryColor = Colors.orange.value
      ..accentColor = Colors.orangeAccent.value;
  }

  static HarpyThemeData get swan {
    return HarpyThemeData()
      ..name = "swan"
      ..backgroundColors = [Colors.white.value, Colors.white.value]
      ..primaryColor = Colors.deepOrangeAccent.value
      ..accentColor = 0xff444444;
  }
}
