import 'package:ootopia_app/shared/shared_preferences.dart';

class ChatDialogController {
  static ChatDialogController? _instance;
  SharedPreferencesInstance? _prefs;
  ChatDialogController() {
    SharedPreferencesInstance.getInstace().then((value) {
      _prefs = value;
    });
  }

  //Method created just so that SharedPreferences is instantiated
  init() {}

  static ChatDialogController get instance =>
      _instance == null ? _instance = ChatDialogController() : _instance!;

  Future<bool> getChatHasAlreadyBeenOpenedToday() async {
    DateTime now = new DateTime.now();
    int? lastChatOpenedDateTimeMs = _prefs?.getLastChatOpenedDateKey();
    if (lastChatOpenedDateTimeMs == null) {
      return false;
    }
    DateTime lastDateTime =
        DateTime.fromMillisecondsSinceEpoch(lastChatOpenedDateTimeMs);

    bool sameDate = (now.day == lastDateTime.day &&
        now.month == lastDateTime.month &&
        now.year == lastDateTime.year);

    if (!sameDate) {
      setChatOpened(false);
    }

    return sameDate && _prefs?.getChatOpened() == true;
  }

  setChatOpened(bool value) {
    _prefs?.setChatOpened(value);
    if (value) {
      _prefs
          ?.setLastChatOpenedDateKey(new DateTime.now().millisecondsSinceEpoch);
    }
  }

  resetSavedData() {
    _prefs?.removeChatOpened();
    _prefs?.removeLastChatOpenedDateKey();
  }
}
