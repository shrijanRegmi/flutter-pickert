import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imhotep/enums/notification_type.dart';
import 'package:imhotep/helpers/common_helper.dart';
import 'package:imhotep/viewmodels/notification_item_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/hotep_button.dart';
import 'package:imhotep/widgets/common_widgets/user_fetcher.dart';
import 'package:peaman/peaman.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../helpers/notification_navigation_helper.dart';

class NotificationListItem extends StatefulWidget {
  final PeamanNotification notification;
  const NotificationListItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  State<NotificationListItem> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  Future<PeamanUser>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = PUserProvider.getUserById(
      uid: widget.notification.senderId!,
    ).first;
  }

  @override
  Widget build(BuildContext context) {
    return VMProvider<NotificationItemVm>(
      vm: NotificationItemVm(context),
      builder: (context, vm, appVm, appUser) {
        Widget _widget = Container();
        final _notificationType =
            NotificationType.values[widget.notification.extraData['type'] ?? 0];

        switch (_notificationType) {
          case NotificationType.reactToComment:
            _widget = _feedItemBuilder(vm);
            break;
          case NotificationType.replyToComment:
            _widget = _feedItemBuilder(vm);
            break;
          case NotificationType.startedFollowing:
            _widget = _startedFollowingItemBuilder(vm, appUser!);
            break;
          case NotificationType.newFeed:
            _widget = _newFeedItemBuilder(vm);
            break;
          default:
        }

        return _widget;
      },
    );
  }

  // NotificationType.reactToComment || NotificationType.replyToComment
  Widget _feedItemBuilder(
    final NotificationItemVm vm,
  ) {
    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        final _user = user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NotificationNavigationHelper(context).navigate(
                  data: widget.notification.extraData,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 25.0,
                ),
                child: Row(
                  children: [
                    AvatarBuilder.image(
                      _user.photoUrl,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: _titleAndBodyBuilder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // NotificationType.startedFollowing
  Widget _startedFollowingItemBuilder(
    final NotificationItemVm vm,
    final PeamanUser appUser,
  ) {
    return UserFetcher.singleFuture(
      userFuture: _userFuture,
      singleBuilder: (user) {
        final _user = user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NotificationNavigationHelper(context).navigate(
                  data: widget.notification.extraData,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  bottom: 25.0,
                ),
                child: Row(
                  children: [
                    AvatarBuilder.image(
                      _user.photoUrl,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _titleAndBodyBuilder(),
                          ),
                          _followBtnBuilder(appUser, vm),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // NotificationType.newFeed
  Widget _newFeedItemBuilder(
    final NotificationItemVm vm,
  ) {
    final _photos =
        List<String>.from(widget.notification.extraData['photos'] ?? []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NotificationNavigationHelper(context).navigate(
              data: widget.notification.extraData,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 25.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: blueColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(13.0),
                  child: SvgPicture.asset(
                    'assets/svgs/sparkling_bell.svg',
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _titleAndBodyBuilder(
                          limit: _photos.isEmpty ? 43 : 33,
                        ),
                      ),
                      if (_photos.isNotEmpty)
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: greyColorshade200,
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                _photos[0],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleAndBodyBuilder({
    final int limit = 43,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.notification.title,
          style: TextStyle(
            color: blackColor,
          ),
        ),
        if (widget.notification.body.trim().isNotEmpty)
          Text(
            CommonHelper.limitedText(
              widget.notification.body,
              limit: limit,
            ),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          timeago.format(
            DateTime.fromMillisecondsSinceEpoch(
              widget.notification.createdAt!,
            ),
          ),
          style: TextStyle(
            fontSize: 10.0,
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget _followBtnBuilder(
    final PeamanUser appUser,
    final NotificationItemVm vm,
  ) {
    final _following = vm.following ?? [];
    final _alreadyFollowing = _following
        .map((e) => e.uid)
        .toList()
        .contains(widget.notification.senderId!);

    if (_alreadyFollowing) return Container();

    return HotepButton.bordered(
      padding: const EdgeInsets.all(0.0),
      value: 'Follow',
      textStyle: TextStyle(
        fontSize: 12.0,
        color: blueColor,
      ),
      borderRadius: 10.0,
      width: 60.0,
      height: 30.0,
      onPressed: () => vm.followBack(
        appUser.uid!,
        widget.notification.senderId!,
      ),
    );
  }
}
