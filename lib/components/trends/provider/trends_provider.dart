import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';
import 'package:rby/rby.dart';

final trendsProvider = StateNotifierProvider.autoDispose<TrendsNotifier,
    AsyncValue<BuiltList<Trend>>>(
  (ref) {
    ref.cacheFor(const Duration(minutes: 5));

    return TrendsNotifier(
      ref: ref,
      bluesky: ref.watch(blueskyProvider),
      userLocation: ref.watch(userTrendsLocationProvider),
    );
  },
  name: 'TrendsProvider',
);

class TrendsNotifier extends StateNotifier<AsyncValue<BuiltList<Trend>>>
    with LoggerMixin {
  TrendsNotifier({
    required Ref ref,
    required dynamic bluesky,
    required TrendsLocationData userLocation,
  })  : _ref = ref,
        _twitterApi = bluesky,
        _trendsLocationData = userLocation,
        super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;
  final dynamic _twitterApi;
  final TrendsLocationData _trendsLocationData;

  Future<void> load() async {
    log.fine('finding trends for ${_trendsLocationData.name}');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        final trends = await _twitterApi.trendsService
            .place(id: _trendsLocationData.woeid)
            .then((trends) => trends.first.trends ?? <Trend>[])
            .then(
              (trends) => trends
                ..sort(
                  (o1, o2) => (o2.tweetVolume ?? 0) - (o1.tweetVolume ?? 0),
                ),
            );
        
        return Future(() => BuiltList());
        //return trends.toBuiltList();
      },
    );
  }

  Future<void> updateLocation({
    required TrendsLocationData location,
  }) async {
    log.fine('updating trends location');

    try {
      _ref
          .read(trendsLocationPreferencesProvider.notifier)
          .setTrendsLocationData(jsonEncode(location.toJson()));
    } catch (e, st) {
      log.severe('unable to update trends location', e, st);
    }
  }
}
