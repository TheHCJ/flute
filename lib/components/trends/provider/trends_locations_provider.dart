import 'package:built_collection/built_collection.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flute/api/api.dart';
import 'package:flute/components/components.dart';
import 'package:flute/core/core.dart';
import 'package:rby/rby.dart';

final trendsLocationsProvider = StateNotifierProvider.autoDispose<
    TrendsLocationsNotifier, AsyncValue<BuiltList<TrendsLocationData>>>(
  (ref) {
    ref.cacheFor(const Duration(minutes: 5));

    return TrendsLocationsNotifier(
      bluesky: ref.watch(blueskyProvider),
    );
  },
  name: 'TrendsLocationsProvider',
);

class TrendsLocationsNotifier
    extends StateNotifier<AsyncValue<BuiltList<TrendsLocationData>>>
    with LoggerMixin {
  TrendsLocationsNotifier({
    required dynamic bluesky,
  })  : _twitterApi = twitterApi,
        super(const AsyncValue.loading()) {
    load();
  }

  final dynamic _twitterApi;

  Future<void> load() async {
    log.fine('loading trends locations');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      /* final locations = await _twitterApi.trendsService.available().then(
            (locations) => locations
                .where(
                  (location) =>
                      location.placeType?.code == 12 &&
                      location.woeid != null &&
                      location.name != null &&
                      location.placeType?.name != null,
                )
                .map(
                  (location) => TrendsLocationData(
                    name: location.name!,
                    woeid: location.woeid!,
                    placeType: location.placeType!.name!,
                    country: location.country ?? '',
                  ),
                )
                .toList()
              ..sort((a, b) => a.name.compareTo(b.name)),
          );

      return locations.toBuiltList();*/
      return Future(() => BuiltList());
    });
  }
}
