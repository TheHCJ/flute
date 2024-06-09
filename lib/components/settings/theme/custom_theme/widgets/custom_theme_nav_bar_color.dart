import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';

class CustomThemeNavBarColor extends ConsumerWidget {
  const CustomThemeNavBarColor({
    required this.notifier,
  });

  final CustomThemeNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final harpyTheme = ref.watch(harpyThemeProvider);

    return CustomThemeColor(
      color: harpyTheme.colors.navBarColor,
      enableAlpha: true,
      title: const Text('navigation bar'),
      subtitle: Text(
        colorValueToDisplayHex(harpyTheme.colors.navBarColor.value),
      ),
      onColorChanged: notifier.changeNavBarColor,
    );
  }
}
