import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';

final predefinedThemesProvider = Provider.autoDispose(
  (ref) => predefinedThemes
      .map(
        (data) => HarpyTheme(
          data: data,
          fontSizeDelta: ref.watch(displayPreferencesProvider).fontSizeDelta,
          displayFont: ref.watch(displayPreferencesProvider).displayFont,
          bodyFont: ref.watch(displayPreferencesProvider).bodyFont,
          compact: ref.watch(displayPreferencesProvider).compactMode,
        ),
      )
      .toBuiltList(),
  name: 'PredefinedThemesProvider',
);

final predefinedProThemesProvider = Provider.autoDispose(
  (ref) => predefinedProThemes
      .map(
        (data) => HarpyTheme(
          data: data,
          fontSizeDelta: ref.watch(displayPreferencesProvider).fontSizeDelta,
          displayFont: ref.watch(displayPreferencesProvider).displayFont,
          bodyFont: ref.watch(displayPreferencesProvider).bodyFont,
          compact: ref.watch(displayPreferencesProvider).compactMode,
        ),
      )
      .toBuiltList(),
  name: 'predefinedProThemesProvider',
);
