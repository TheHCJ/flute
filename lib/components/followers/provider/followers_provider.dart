import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';

final followersProvider = StateNotifierProvider.autoDispose
    .family<FollowersNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, handle) => FollowersNotifier(
    ref: ref,
    bluesky: ref.watch(blueskyProvider),
    handle: handle,
  ),
  name: 'FollowersProvider',
);

class FollowersNotifier extends PaginatedUsersNotifier {
  FollowersNotifier({
    required Ref ref,
    required dynamic bluesky,
    required String handle,
  })  : _ref = ref,
        _twitterApi = bluesky,
        _handle = handle,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Ref _ref;
  final dynamic _twitterApi;
  final String _handle;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_ref, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    /* return _twitterApi.userService.followersList(
      screenName: _handle,
      cursor: cursor,
      skipStatus: true,
      count: 200,
    );
    */
    return Future(() => PaginatedUsers());
  }
}
