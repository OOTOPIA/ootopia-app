import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesInstance {
  static SharedPreferences? prefs;
  static SharedPreferencesInstance? _instance;

  SharedPreferencesInstance() {}

  static Future<SharedPreferencesInstance> getInstace() async {
    if (_instance == null) {
      _instance = SharedPreferencesInstance();
      prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<bool> setAuthToken(String value) async {
    await prefs?.setString("auth_token", value) ?? false;
    return true;
  }

  String? getAuthToken() {
    return prefs?.getString("auth_token");
  }

  Future<bool> setGlobalGoalLimitTimeInUtc(String value) async {
    return await prefs?.setString("global_goal_limit_time_in_utc", value) ??
        false;
  }

  String? getGlobalGoalLimitTimeInUtc() {
    return prefs?.getString("global_goal_limit_time_in_utc");
  }

  int? getLastChatOpenedDateKey() {
    return prefs?.getInt("last_chat_opened_date");
  }

  Future<bool> setLastChatOpenedDateKey(int value) async {
    return await prefs?.setInt("last_chat_opened_date", value) ?? false;
  }

  Future<bool> removeLastChatOpenedDateKey() async {
    return await prefs?.remove("last_chat_opened_date") ?? false;
  }

  bool? getChatOpened() {
    return prefs?.getBool("chat_opened");
  }

  Future<bool> setChatOpened(bool value) async {
    return await prefs?.setBool("chat_opened", value) ?? false;
  }

  Future<bool> removeChatOpened() async {
    return await prefs?.remove("chat_opened") ?? false;
  }

  bool? getPersonalCelebratePageEnabled() {
    return prefs?.getBool("show_personal_celebrate_page");
  }

  Future<bool> setPersonalCelebratePageEnabled(bool value) async {
    return await prefs?.setBool("show_personal_celebrate_page", value) ?? false;
  }

  bool? getPersonalCelebratePageAlreadyOpened() {
    return prefs?.getBool("personal_celebrate_page_already_opened");
  }

  Future<bool> setPersonalCelebratePageAlreadyOpened(bool value) async {
    return await prefs?.setBool(
            "personal_celebrate_page_already_opened", value) ??
        false;
  }

  bool? getDontShowAgainRegenerationGamePega() {
    return prefs?.getBool('dontShowAgainRegenerationGamePega');
  }

  Future<bool> setDontShowAgainRegenerationGamePega(bool value) async {
    return await prefs?.setBool('dontShowAgainRegenerationGamePega', value) ??
        false;
  }

  int? getTimelineViewTime() {
    return prefs?.getInt('timeline_view_time');
  }

  Future<bool> setTimelineViewTime(int value) async {
    return await prefs?.setInt('timeline_view_time', value) ?? false;
  }

  String? getLastSplashScreenOpening() {
    return prefs?.getString('last_splash_screen_opening_date');
  }

  Future<bool> setLastSplashScreenOpening(String value) async {
    return await prefs?.setString('last_splash_screen_opening_date', value) ??
        false;
  }

  String? getLanguageConfig() {
    return prefs?.getString('language_config');
  }

  Future<bool> setLanguageConfig(String value) async {
    return await prefs?.setString('language_config', value) ?? false;
  }

  Future<bool> setLastUsageTime(int value) async {
    return await prefs?.setInt("last_usage_time", value) ?? false;
  }

  int? getLastUsageTime() {
    return prefs?.getInt("last_usage_time");
  }

  Future<bool> setFeedbackTime(int value) async {
    return await prefs?.setInt("feedback_time", value) ?? false;
  }

  int? getFeedbackTime() {
    return prefs?.getInt("feedback_time");
  }

  Future<bool> setFeedbackToday(bool value) async {
    return await prefs?.setBool("feedback_today", value) ?? false;
  }

  bool? getFeedbackToday() {
    return prefs?.getBool("feedback_today");
  }

  Future<bool> setFeedbackLastUsageDate(String value) async {
    return await prefs?.setString("feedback_last_usage_date", value) ?? false;
  }

  String? getFeedbackLastUsageDate() {
    return prefs?.getString("feedback_last_usage_date");
  }

  Future<bool> setLastPendingUsageTime(int value) async {
    return await prefs?.setInt("last_pending_usage_time", value) ?? false;
  }

  int? getLastPendingUsageTime() {
    return prefs?.getInt("last_pending_usage_time");
  }

  Future<bool> setLastPendingUsageDate(String value) async {
    return await prefs?.setString("last_pending_usage_date", value) ?? false;
  }

  String? getLastPendingUsageDate() {
    return prefs?.getString("last_pending_usage_date");
  }

  Future<bool> setShowSplash(bool value) async {
    return await prefs?.setBool("showSplash", value) ?? false;
  }

  bool? getShowSplash() {
    return prefs?.getBool("showSplash");
  }
}
