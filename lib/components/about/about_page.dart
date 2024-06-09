import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';
import 'package:rby/rby.dart';

class AboutPage extends StatelessWidget {
  const AboutPage();

  static const name = 'about';
  static const path = '/about_harpy';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HarpyScaffold(
      child: CustomScrollView(
        slivers: [
          HarpySliverAppBar(
            title: const Text('about'),
            actions: [
              RbyPopupMenuButton(
                onSelected: (_) => showLicensePage(context: context),
                itemBuilder: (_) => const [
                  RbyPopupMenuListTile(
                    value: true,
                    title: Text('licenses'),
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: theme.spacing.edgeInsets,
            sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed([
                _HarpyLogo(),
                VerticalSpacer.normal,
                _SummaryCard(),
                VerticalSpacer.normal,
                _PrivacyPolicyCard(),
              ]),
            ),
          ),
          const SliverBottomPadding(),
        ],
      ),
    );
  }
}

class _HarpyLogo extends StatelessWidget {
  const _HarpyLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 100,
          child: FlareAnimation.harpyTitle(
            animation: 'show',
            color: theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(
          height: 100,
          child: FlareAnimation.harpyLogo(animation: 'show'),
        ),
      ],
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final version = ref.watch(deviceInfoProvider).packageInfo?.version;
    final launcher = ref.watch(launcherProvider);

    final isAuthenticated =
        ref.watch(authenticationStateProvider).isAuthenticated;

    final style = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      child: Column(
        children: [
          RbyListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'version $version',
              style: theme.textTheme.titleMedium,
            ),
            borderRadius: BorderRadius.only(
              topLeft: theme.shape.radius,
              topRight: theme.shape.radius,
            ),
            onTap: () => context.pushNamed(ChangelogPage.name),
          ),
          RbyListTile(
            leading: const Icon(FeatherIcons.github),
            title: const Text('flute on GitHub'),
            subtitle: Text('github.com/TheHCJ/flute', style: style),
            onTap: () => launcher('https://github.com/TheHCJ/flute'),
          ),
          RbyListTile(
            title: const Text('flute on Bluesky'),
            subtitle: Text('@fluteapp.bsky.social', style: style),
            leading: const Icon(FeatherIcons.atSign),
            borderRadius: BorderRadius.only(
              bottomLeft: theme.shape.radius,
              bottomRight: theme.shape.radius,
            ),
            onTap: isAuthenticated
                ? () => context.pushNamed(
                      UserPage.name,
                      params: {'handle': 'fluteapp.bsky.social'},
                    )
                : () => launcher('https://bsky.app/profile/fluteapp.bsky.social'),
          ),
        ],
      ),
    );
  }
}

class _PrivacyPolicyCard extends ConsumerWidget {
  const _PrivacyPolicyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcher = ref.watch(launcherProvider);

    return RbyListCard(
      leading: const Icon(CupertinoIcons.exclamationmark_shield),
      title: const Text('privacy policy'),
      onTap: () => launcher(
        'https://github.com/TheHCJ/flute/blob/master/PRIVACY.md',
      ),
    );
  }
}
