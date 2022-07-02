import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../screens/followers_following_screen.dart';

enum _Type {
  personal,
  friend,
}

class ProfilePropertiesCount extends StatelessWidget {
  final int articlesViewed;
  final int repliesReceived;
  final int likeableComments;
  final int followers;
  final int following;
  final _Type type;

  const ProfilePropertiesCount.personal({
    Key? key,
    this.articlesViewed = 0,
    this.repliesReceived = 0,
    this.likeableComments = 0,
    this.followers = 0,
    this.following = 0,
  })  : type = _Type.personal,
        super(key: key);

  const ProfilePropertiesCount.friend({
    Key? key,
    this.articlesViewed = 0,
    this.repliesReceived = 0,
    this.likeableComments = 0,
    this.followers = 0,
    this.following = 0,
  })  : type = _Type.friend,
        super(key: key);

  void _gotoFollowers(final BuildContext context) {
    if (type == _Type.friend) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FollowersFollowingScreen.followers(),
      ),
    );
  }

  void _gotoFollowing(final BuildContext context) {
    if (type == _Type.friend) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FollowersFollowingScreen.following(),
      ),
    );
  }

  // format number to display 1K, 1M etc
  String formatNumber(final int num) {
    final _format = NumberFormat.compact().format(num);
    return _format;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _itemBuilder(
        //   count: articlesViewed,
        //   title: 'Articles\nviewed',
        // ),
        // _divider(),
        _itemBuilder(
          count: repliesReceived,
          title: 'Replies\nreceived',
        ),
        _divider(),
        _itemBuilder(
          count: likeableComments,
          title: 'Likeable\ncomments',
        ),
        _divider(),
        _itemBuilder(
          count: followers,
          title: 'Followers\n',
          blue: true,
          onPressed: () => _gotoFollowers(context),
        ),
        _divider(),
        _itemBuilder(
          count: following,
          title: 'Follows\n',
          blue: true,
          onPressed: () => _gotoFollowing(context),
        ),
      ],
    );
  }

  Widget _itemBuilder({
    required final int count,
    required final String title,
    final bool blue = false,
    final Function()? onPressed,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Column(
        children: [
          Text(
            formatNumber(count),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: blue ? blueColor : blackColor,
              fontSize: 18.0,
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: blue ? blueColor : blackColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 3.0,
      height: 50.0,
      color: greyColor.withOpacity(0.2),
    );
  }
}
