import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';

class CustomThemeCardColor extends ConsumerWidget {
  const CustomThemeCardColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return CustomThemeColor(
      color: harpyTheme.colors.cardColor,
      enableAlpha: true,
      title: const Text('card'),
      subtitle: Text(
        colorValueToDisplayHex(harpyTheme.colors.cardColor.value),
      ),
      onColorChanged: notifier.changeCardColor,
    );
  }
}
