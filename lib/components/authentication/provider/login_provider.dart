import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';
import 'package:rby/rby.dart';
import 'package:twitter_webview_auth/twitter_webview_auth.dart';

/// Handles login.
///
/// Authentication logic is split between
/// * [authenticationProvider]
/// * [loginProvider]
/// * [logoutProvider]
final loginProvider = Provider(
  (ref) => _Login(
    ref: ref,
    environment: ref.watch(environmentProvider),
  ),
  name: 'LoginProvider',
);

class _Login with LoggerMixin {
  const _Login({
    required Ref ref,
    required Environment environment,
  })  : _ref = ref,
        _environment = environment;

  final Ref _ref;
  final Environment _environment;

  /// Initializes a web based twitter authentication.
  ///
  /// Navigates to
  /// * [HomePage] on successful authentication
  /// * [SetupPage] on successful authentication if the setup has not yet been
  ///   completed
  /// * [LoginPage] when authentication was not successful.
  Future<void> login(BuildContext context) async {
    log.fine('logging in');

    _ref.read(authenticationStateProvider.notifier).state =
        const AuthenticationState.unauthenticated();

    unawaited(showDialog(context: context, builder: (c) {
      return RbyDialog(
        title: const Text("login"),
        content: Column(children: [
          const TextField(decoration: InputDecoration(hintText: "handle or email"),),
          VerticalSpacer.normal,
          const TextField(decoration: InputDecoration(hintText: "app password"),),
          VerticalSpacer.normal,
          RbyButton.text(onTap: (){}, label: Text("login with Bluesky"),)
        ],));
    }));

    final result = null;

    await result.when(
      success: (token, secret, userId) async {
        log.fine('successfully authenticated');

        _ref.read(authPreferencesProvider.notifier).setAuth(
              token: "",
              secret: "secret",
              userId: "userId",
            );

        await _ref
            .read(authenticationProvider)
            .onLogin(_ref.read(authPreferencesProvider));

        if (_ref.read(authenticationStateProvider).isAuthenticated) {
          if (_ref.read(setupPreferencesProvider).performedSetup) {
            _ref.read(routerProvider).goNamed(
              HomePage.name,
              queryParams: {'transition': 'fade'},
            );
          } else {
            _ref.read(routerProvider).goNamed(SetupPage.name);
          }
        } else {
          _ref.read(routerProvider).goNamed(LoginPage.name);
        }
      },
      failure: (e) {
        log.warning(
          'login failed\n\n'
          'If this issue is persistent, see\n'
          'https://github.com/robertodoering/harpy/wiki/Troubleshooting',
          e,
          
        );

        _ref.read(messageServiceProvider).showSnackbar(
              const SnackBar(
                content: Text('authentication failed, please try again'),
              ),
            );

        _ref.read(authenticationStateProvider.notifier).state =
            const AuthenticationState.unauthenticated();

        _ref.read(routerProvider).goNamed(LoginPage.name);
      },
      cancelled: () {
        log.fine('login cancelled by user');

        _ref.read(authenticationStateProvider.notifier).state =
            const AuthenticationState.unauthenticated();

        _ref.read(routerProvider).goNamed(LoginPage.name);
      },
    );
  }

  /// Used by [TwitterAuth] to navigate to the login webview page.
  Future<Uri?> _webviewNavigation(TwitterLoginWebview webview) async {
    return _ref.read(routerProvider).navigator?.push<Uri?>(
          SlidePageRoute(
            builder: (_) => LoginWebview(webview: webview),
          ),
        );
  }
}
