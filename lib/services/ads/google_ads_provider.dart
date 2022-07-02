import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imhotep/enums/subscription_type.dart';
import 'package:imhotep/models/ad_config.dart';
import 'package:imhotep/models/app_user_extra_data_model.dart';
import 'package:imhotep/viewmodels/app_vm.dart';
import 'package:peaman/peaman.dart';
import 'package:provider/provider.dart';

class GoogleAdsProvider {
  static final _ref = Peaman.ref;

  static RewardedAd? _rewardedAd;
  static bool _rewardedAdLoaded = false;
  static bool get rewardedAdLoaded => _rewardedAdLoaded;

  // load interstial ad
  static void loadInterstitialAd({
    required final BuildContext context,
    final Function(Ad)? onAdLoaded,
    final Function(LoadAdError)? onAdFailedToLoad,
  }) async {
    final _currentDate = DateTime.now();
    final _appVm = context.read<AppVm>();
    final _adConfig = context.read<AdConfig>();
    final _appUser = context.read<PeamanUser>();
    final _appUserExtraData = AppUserExtraData.fromJson(
      _appUser.extraData,
    );
    final _nextAdDate = DateTime.fromMillisecondsSinceEpoch(
      _appUserExtraData.nextAdAt,
    );

    var _adsWatched = _appUserExtraData.adsWatched;
    if (_adsWatched >= _adConfig.maxGoogleAdsPerDay &&
        (_currentDate.isAtSameMomentAs(_nextAdDate) ||
            _currentDate.isAfter(_nextAdDate))) {
      _adsWatched = 0;
    }

    final _showAd =
        _appUserExtraData.subscriptionType == SubscriptionType.level3
            ? false
            : _adsWatched < _adConfig.maxGoogleAdsPerDay &&
                (_currentDate.isAtSameMomentAs(_nextAdDate) ||
                    _currentDate.isAfter(_nextAdDate)) &&
                _appVm.showAds;

    if (!_showAd) return;

    _appVm.updateShowAds(false);
    InterstitialAd.load(
      adUnitId: _adConfig.interstitialId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          PUserProvider.updateUserData(
            uid: _appUser.uid!,
            data: {'ads_watched': PeamanDatabaseHelper.fieldValueIncrement(1)},
          );
          if (_appUserExtraData.adsWatched ==
              (_adConfig.maxGoogleAdsPerDay - 1)) {
            final _newNextAdsDate = DateTime(
              _currentDate.year,
              _currentDate.month,
              _currentDate.day,
            ).add(Duration(days: 1));
            PUserProvider.updateUserData(
              uid: _appUser.uid!,
              data: {'next_ad_at': _newNextAdsDate.millisecondsSinceEpoch},
            );
          } else {
            final _newNextAdsDate = DateTime(
              _currentDate.year,
              _currentDate.month,
              _currentDate.day,
              _currentDate.hour,
              _currentDate.minute,
            ).add(Duration(
              milliseconds: _adConfig.minDurationToShowAds,
            ));
            PUserProvider.updateUserData(
              uid: _appUser.uid!,
              data: {'next_ad_at': _newNextAdsDate.millisecondsSinceEpoch},
            );
          }

          await ad.show();
          Future.delayed(Duration(milliseconds: 2000), () {
            _appVm.updateShowAds(true);
          });
          print('Succes: Loading interstitial ad');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (err) {
          print(err);
          print('Error!!!: Loading interstitial ad');
          _appVm.updateShowAds(true);
          if (_adConfig.logErrorsForAll) {
            logErrors(
              err: err,
              appUser: _appUser,
            );
          } else if (_adConfig.logErrors &&
              (_appUser.admin || _appUser.editor)) {
            logErrors(
              err: err,
              appUser: _appUser,
            );
          }
          onAdFailedToLoad?.call(err);
        },
      ),
    );
  }

  // load rewarded ad
  static Future<dynamic> loadRewardedAd({
    required final BuildContext context,
    final Function()? onAdLoaded,
  }) async {
    final _adConfig = context.read<AdConfig>();
    final _appUser = context.read<PeamanUser>();

    return RewardedAd.load(
      adUnitId: _adConfig.rewardedId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAdLoaded = true;
          onAdLoaded?.call();
          print('Success: Loading rewarded ad');
        },
        onAdFailedToLoad: (LoadAdError err) {
          print(err);
          print('Error!!!: Loading rewarded ad');
          if (_adConfig.logErrorsForAll) {
            logErrors(
              err: err,
              appUser: _appUser,
            );
          } else if (_adConfig.logErrors &&
              (_appUser.admin || _appUser.editor)) {
            logErrors(
              err: err,
              appUser: _appUser,
            );
          }
        },
      ),
    );
  }

  // show rewarded ad
  static void showRewardedAd({
    final Function()? onRewarded,
    final Function()? onAdClose,
  }) {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        _rewardedAd = null;
        _rewardedAdLoaded = false;
        ad.dispose();
        onAdClose?.call();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        _rewardedAd = null;
        _rewardedAdLoaded = false;
        ad.dispose();
        onAdClose?.call();
      },
    );
    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        _rewardedAd = null;
        _rewardedAdLoaded = false;
        onRewarded?.call();
      },
    );
  }

  // log errors for ad
  static Future<void> logErrors({
    required final LoadAdError err,
    required final PeamanUser appUser,
  }) async {
    try {
      final _addErrorsRef = _ref.collection('ad_errors').doc();
      final _data = <String, dynamic>{
        'id': _addErrorsRef.id,
        'uid': appUser.uid,
        'code': err.code,
        'message': err.message,
        'response_info': err.responseInfo.toString(),
        'domain': err.domain,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };
      await _addErrorsRef.set(_data);
      print('Success: Logging errors for user');
    } catch (e) {
      print(e);
      print('Error!!!: Logging errors for user');
    }
  }

  // ad config from firestore
  static AdConfig _adConfigFromFirestore(final dynamic snap) {
    return AdConfig.fromJson(snap.data() ?? {});
  }

  // stream of ad config
  static Stream<AdConfig> get adConfig {
    return _ref
        .collection('configs')
        .doc('ads_config')
        .snapshots()
        .map(_adConfigFromFirestore);
  }
}
