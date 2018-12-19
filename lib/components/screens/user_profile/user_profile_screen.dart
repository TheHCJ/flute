import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:harpy/api/twitter/data/url.dart';
import 'package:harpy/api/twitter/data/user.dart';
import 'package:harpy/components/shared/scaffolds.dart';
import 'package:harpy/components/shared/tweet_list.dart';
import 'package:harpy/components/shared/twitter_text.dart';
import 'package:harpy/components/shared/util.dart';
import 'package:harpy/core/utils/date_utils.dart';
import 'package:harpy/core/utils/url_launcher.dart';
import 'package:harpy/stores/tokens.dart';
import 'package:harpy/stores/user_store.dart';
import 'package:harpy/theme.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  UserProfileScreen(this.user);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with StoreWatcherMixin<UserProfileScreen> {
  UserStore store;

  bool _loadingTweets = true;

  @override
  void initState() {
    super.initState();
    store = listenToStore(Tokens.user);

    _initUserTweets();
  }

  void _initUserTweets() {
    UserStore.initUserTweets(widget.user).then((_) {
      setState(() {
        _loadingTweets = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    unlistenFromStore(store);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HarpyTheme.theme,
      child: FadingNestedScaffold(
        title: widget.user.name,
        background: CachedNetworkImage(
          imageUrl: widget.user.profile_banner_url ??
              widget.user.profileBackgroundImageUrl,
          fit: BoxFit.cover,
        ),
        body: TweetList(
          leading: UserHeader(user: widget.user),
          tweets: _loadingTweets ? null : store.userTweets,
          trailing: _buildTrailingWidget(),
        ),
      ),
    );
  }

  /// Builds a [CircularProgressIndicator] if the tweets are loading or a [Text]
  /// if no tweets were able to be fetched.
  Widget _buildTrailingWidget() {
    if (_loadingTweets) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (store.userTweets?.isEmpty ?? false) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(child: Text("No tweets q.q")),
      );
    } else {
      return Container();
    }
  }
}

/// The [UserHeader] containing the information about the [User].
class UserHeader extends StatefulWidget {
  final User user;

  const UserHeader({@required this.user});

  @override
  _UserHeaderState createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  GestureRecognizer _linkGestureRecognizer;

  @override
  void dispose() {
    super.dispose();

    _linkGestureRecognizer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildUserInfo(),
          SizedBox(height: 8.0),
          _buildUserDescription(),
          _buildAdditionalInfo(),
          FollowersCount(
            followers: widget.user.followersCount,
            following: widget.user.friendsCount,
          )
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 36.0,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(
            widget.user.userProfileImageOriginal,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.user.name,
                style: Theme.of(context).textTheme.display2,
              ),
              Text(
                "@" + widget.user.screenName,
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserDescription() {
    // todo (low priority): parse hashtags in description
    return Column(
      children: <Widget>[
        TwitterText(
          text: widget.user.description,
          entities: widget.user.entities.asEntities,
          onEntityTap: (entityModel) {
            if (entityModel.type == EntityType.url) {
              launchUrl(entityModel.url);
            }
          },
        ),
      ],
    );
  }

  /// Builds a [Column] of icon rows with additional information such as the
  /// link, date joined or location of the [User].
  Widget _buildAdditionalInfo() {
    List<Widget> children = [];

    if (widget.user?.entities?.url?.urls?.isNotEmpty ?? false) {
      children.add(_buildLink());
    }

    if (widget.user.location?.isNotEmpty ?? false) {
      children.add(IconRow(icon: Icons.place, child: widget.user.location));
    }

    if (widget.user.createdAt != null) {
      children.add(IconRow(
        icon: Icons.date_range,
        child: "joined ${formatCreatedAt(widget.user.createdAt)}",
      ));
    }

    return children.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: children),
          )
        : Container();
  }

  /// A helper method to create a link in [_buildAdditionalInfo].
  Widget _buildLink() {
    Url url = widget.user.entities.url.urls.first;

    _linkGestureRecognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(url.url);

    Widget text = RichText(
      text: TextSpan(
        text: "${url.displayUrl} ",
        style: HarpyTheme.theme.textTheme.body1.copyWith(
          color: HarpyTheme.primaryColor, // todo: user color?
          fontWeight: FontWeight.bold,
        ),
        recognizer: _linkGestureRecognizer,
      ),
    );

    return IconRow(icon: Icons.link, child: text);
  }
}
