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
            accessJwt: preferences.getString('accessJwt', ''),
            did: preferences.getString('did', ''),
            email: preferences.getString('email', ''),
            handle: preferences.getString('handle', ''),
            refreshJwt: preferences.getString('refreshJwt', ''),
          ),
        );

  final Preferences _preferences;

  void setAuth({
    required String accessJwt,
    required String did,
    required String? email,
    required String handle,
    required String refreshJwt,
  }) {
    state = AuthPreferences(
      accessJwt: accessJwt,
        did: did,
        email: email,
        handle: handle,
        refreshJwt: refreshJwt
    );

    _preferences
      ..setString('accessJwt', accessJwt)
      ..setString('did', did)
      ..setString('email', email ?? '')
      ..setString('handle', handle)
      ..setString('refreshJwt', refreshJwt);
  }

  void clearAuth() {
    state = AuthPreferences.empty();

    _preferences
      ..remove('accessJwt')
      ..remove('did')
      ..remove('email')
      ..remove('handle')
      ..remove('refreshJwt');
  }
}

@freezed
class AuthPreferences with _$AuthPreferences {
  factory AuthPreferences({
    required String accessJwt,
    required String did,
    required String? email,
    required String handle,
    required String refreshJwt,
  }) = _AuthPreferences;

  factory AuthPreferences.empty() => AuthPreferences(
        accessJwt: '',
        did: '',
        email: '',
        handle: '',
        refreshJwt: ''
      );

  AuthPreferences._();

  late final bool isValid =
      accessJwt.isNotEmpty 
      && did.isNotEmpty 
      && email != null 
      && handle.isNotEmpty 
      && refreshJwt.isNotEmpty;
}
