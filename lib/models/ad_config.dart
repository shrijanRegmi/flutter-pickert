class AdConfig {
  final String bannerId;
  final String interstitialId;
  final String rewardedId;
  final bool logErrors;
  final bool logErrorsForAll;
  final int maxGoogleAdsPerDay;
  final double chancesToShowCustomAds;
  final double chancesToShowRewardedAds;
  final int minDurationToShowAds;
  final int storiesAdInBetween;

  AdConfig({
    this.bannerId = '',
    this.interstitialId = '',
    this.rewardedId = '',
    this.logErrors = false,
    this.logErrorsForAll = false,
    this.maxGoogleAdsPerDay = -1,
    this.chancesToShowCustomAds = 50.0,
    this.chancesToShowRewardedAds = 50.0,
    this.minDurationToShowAds = 900000,
    this.storiesAdInBetween = 2,
  });

  static AdConfig fromJson(final Map<String, dynamic> data) {
    return AdConfig(
      bannerId: data['banner_id'] ?? '',
      interstitialId: data['interstitial_id'] ?? '',
      rewardedId: data['rewarded_id'] ?? '',
      logErrors: data['log_errors'] ?? false,
      logErrorsForAll: data['log_errors_for_all'] ?? false,
      maxGoogleAdsPerDay: data['max_google_ads_per_day'] ?? -1,
      chancesToShowCustomAds: double.parse(
        '${data['chances_to_show_custom_ads'] ?? 10.0}',
      ),
      chancesToShowRewardedAds: double.parse(
        '${data['chances_to_show_rewarded_ads'] ?? 50.0}',
      ),
      minDurationToShowAds: data['min_duration_to_show_ads'] ?? 900000,
      storiesAdInBetween: data['stories_ads_in_between'] ?? 2,
    );
  }
}
