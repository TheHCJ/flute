import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/misc/environment.dart';
import 'package:bluesky/bluesky.dart' as bsky;

final blueskyProvider = Provider(
  name: 'blueskyProvider',
  (ref) async {
    final authPreferences = ref.watch(authPreferencesProvider);

    return bsky.createSession(
      identifier: authPreferences.userIdentifier, 
      password: authPreferences.userPassword
    );
  },
);