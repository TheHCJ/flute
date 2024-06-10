import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flute/core/core.dart';
import 'package:rby/rby.dart';

part 'auth_preferences.freezed.dart';

/// Handles storing and updating the authentication data for a sessions.
final authPreferencesProvider =
    StateNotifierProvider<AuthPreferencesNotifier, AuthPreferences>(
  (ref) => AuthPreferencesNotifier(
    preferences: ref.watch(encryptedPreferencesProvider(null)),
  ),
  name: 'AuthPreferencesProvider',
);

class AuthPreferencesNotifier extends StateNotifier<AuthPreferences> {
  AuthPreferencesNotifier({
    required Preferences preferences,
  })  : _preferences = preferences,
        super(
          AuthPreferences(
            userIdentifier: preferences.getString('userIdentifier', ''),
            userPassword: preferences.getString('userPassword', ''),
            userDid: preferences.getString('userDid', ''),
          ),
        );

  final Preferences _preferences;

  void setAuth({
    required String indentifier,
    required String password,
    required String userDid,
  }) {
    state = AuthPreferences(
      userIdentifier: indentifier,
      userPassword: password,
      userDid: userDid,
    );

    _preferences
      ..setString('userIdentifier', indentifier)
      ..setString('userPassword', password)
      ..setString('userDid', userDid);
  }

  void clearAuth() {
    state = AuthPreferences.empty();

    _preferences
      ..remove('userIdentifier')
      ..remove('userPassword')
      ..remove('userDid');
  }
}

@freezed
class AuthPreferences with _$AuthPreferences {
  factory AuthPreferences({
    required String userIdentifier,
    required String userPassword,
    required String userDid,
  }) = _AuthPreferences;

  factory AuthPreferences.empty() => AuthPreferences(
        userIdentifier: '',
        userPassword: '',
        userDid: '',
      );

  AuthPreferences._();

  late final bool isValid =
      userIdentifier.isNotEmpty && userPassword.isNotEmpty && userDid.isNotEmpty;
}
