import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';

final listMembersProvider = StateNotifierProvider.autoDispose
    .family<ListsMembersNotifier, PaginatedState<BuiltList<UserData>>, String>(
  (ref, listId) => ListsMembersNotifier(
    ref: ref,
    bluesky: ref.watch(blueskyProvider),
    listId: listId,
  ),
  name: 'ListMembersProvider',
);

class ListsMembersNotifier extends PaginatedUsersNotifier {
  ListsMembersNotifier({
    required Ref ref,
    required dynamic bluesky,
    required String listId,
  })  : _ref = ref,
        _twitterApi = bluesky,
        _listId = listId,
        super(const PaginatedState.loading()) {
    loadInitial();
  }

  final Ref _ref;
  final dynamic _twitterApi;
  final String _listId;

  @override
  Future<void> onRequestError(Object error, StackTrace stackTrace) async =>
      twitterErrorHandler(_ref, error, stackTrace);

  @override
  Future<PaginatedUsers> request([int? cursor]) {
    /* return _twitterApi.listsService.members(
      listId: _listId,
      cursor: cursor?.toString(),
      skipStatus: true,
      count: 200,
    );
    */
    return Future(() => PaginatedUsers());
  }
}
