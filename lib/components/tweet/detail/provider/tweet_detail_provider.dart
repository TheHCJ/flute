import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';

final tweetDetailProvider = StateNotifierProvider.family
    .autoDispose<TweetDetailNotifier, AsyncValue<LegacyTweetData>, String>(
  name: 'TweetDetailProvider',
  (ref, id) => TweetDetailNotifier(
    id: id,
    bluesky: ref.watch(blueskyProvider),
  ),
);

class TweetDetailNotifier extends StateNotifier<AsyncValue<LegacyTweetData>> {
  TweetDetailNotifier({
    required String id,
    required dynamic bluesky,
  })  : _id = id,
        _twitterApi = bluesky,
        super(const AsyncValue.loading());

  final String _id;
  final dynamic _twitterApi;

  Future<void> load([LegacyTweetData? tweet]) async {
    if (tweet != null) {
      state = AsyncData(tweet);
    } else {
      /*
      state = await AsyncValue.guard(
        () => _twitterApi.tweetService
            .show(id: _id)
            .then(LegacyTweetData.fromTweet),
      );
      */
    }
  }
}
