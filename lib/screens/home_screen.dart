import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imhotep/screens/main_tabs/explore_tab.dart';
import 'package:imhotep/screens/main_tabs/chats_tab.dart';
import 'package:imhotep/screens/main_tabs/shop_tab.dart';
import 'package:imhotep/screens/main_tabs/profile_tab.dart';
import 'package:imhotep/viewmodels/home_vm.dart';
import 'package:imhotep/viewmodels/vm_provider.dart';
import 'package:imhotep/widgets/common_widgets/avatar_builder.dart';
import 'package:imhotep/widgets/common_widgets/rounded_icon_button.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';
import '../services/ads/google_ads_provider.dart';
import '../widgets/common_widgets/circular_number_indicator.dart';
import 'main_tabs/feeds_search_tab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = context.watch<PeamanUser?>();
    final _chats = context.watch<List<PeamanChat>?>();
    return VMProvider<HomeVm>(
      vm: HomeVm(context),
      loading: _appUser == null || _chats == null,
      onLoadingCompleted: (vm) => vm.onInit(_appUser!),
      builder: (context, vm, appVm, appUser) {
        return WillPopScope(
          onWillPop: () async {
            if (vm.activeIndex == 0) {
              return true;
            } else {
              vm.scrollToExploreTab(_tabController);
              return false;
            }
          },
          child: Scaffold(
            body: _tabViewBuilder(vm),
            bottomNavigationBar: _tabBarBuilder(appUser!, vm),
          ),
        );
      },
    );
  }

  Widget _tabViewBuilder(final HomeVm vm) {
    return TabBarView(
      controller: _tabController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ExploreTab(),
        ChatsTab(),
        FeedsSearchTab(),
        ShopTab(),
        ProfileTab(),
      ],
    );
  }

  Widget _tabBarBuilder(
    final PeamanUser appUser,
    final HomeVm vm,
  ) {
    return Container(
      color: Color(0xff302f35),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        onTap: (val) {
          vm.updateActiveIndex(val);
          GoogleAdsProvider.loadInterstitialAd(context: context);
        },
        tabs: [
          RoundIconButton(
            icon: SvgPicture.asset(
              'assets/svgs/explore_tab.svg',
              color: vm.activeIndex == 0 ? Colors.white : Color(0xff302f35),
            ),
            bgColor: vm.activeIndex == 0 ? Colors.black : Colors.white,
          ),
          RoundIconButton(
            icon: SvgPicture.asset(
              'assets/svgs/chats_tab.svg',
              color: vm.activeIndex == 1 ? Colors.white : Color(0xff302f35),
            ),
            overlayWidget: CircularNumberIndicator(
              num: vm.chats.where((element) {
                final _myId = appUser.uid!;
                return (_myId == element.firstUserId
                        ? element.firstUserUnreadMessagesCount > 0
                        : element.secondUserUnreadMessagesCount > 0) &&
                    element.chatRequestStatus ==
                        PeamanChatRequestStatus.accepted;
              }).length,
            ),
            bgColor: vm.activeIndex == 1 ? Colors.black : Colors.white,
          ),
          RoundIconButton(
            icon: SvgPicture.asset(
              'assets/svgs/articles_tab.svg',
              color: vm.activeIndex == 2 ? Colors.white : Color(0xff302f35),
            ),
            bgColor: vm.activeIndex == 2 ? Colors.black : Colors.white,
          ),
          RoundIconButton(
            icon: SvgPicture.asset(
              'assets/svgs/shop_tab.svg',
              color: vm.activeIndex == 3 ? Colors.white : Color(0xff302f35),
            ),
            bgColor: vm.activeIndex == 3 ? Colors.black : Colors.white,
          ),
          AvatarBuilder.image(
            appUser.photoUrl,
            size: 50.0,
            border: true,
            borderColor: vm.activeIndex == 4 ? Colors.black87 : Colors.white,
          ),
        ],
      ),
    );
  }
}
