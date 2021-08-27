import 'package:shared_preferences/shared_preferences.dart';

class ChatDialogController {
  static ChatDialogController? _instance;
  SharedPreferences? _prefs;

  String _lastChatOpenedDateKey = "last_chat_opened_date";
  String _chatOpenedKey = "chat_opened";

  ChatDialogController() {
    SharedPreferences.getInstance().then((p) => _prefs = p);
  }

  //Method created just so that SharedPreferences is instantiated
  init() {}

  static ChatDialogController get instance =>
      _instance == null ? _instance = ChatDialogController() : _instance!;

  Future<bool> getChatHasAlreadyBeenOpenedToday() async {
    DateTime now = new DateTime.now();
    int? lastChatOpenedDateTimeMs = _prefs!.getInt(_lastChatOpenedDateKey);
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

    return sameDate && _prefs!.getBool(_chatOpenedKey) == true;
  }

  setChatOpened(bool value) {
    _prefs!.setBool(_chatOpenedKey, value);
    if (value) {
      _prefs!.setInt(
          _lastChatOpenedDateKey, new DateTime.now().millisecondsSinceEpoch);
    }
  }

  resetSavedData() {
    _prefs!.remove(_chatOpenedKey);
    _prefs!.remove(_lastChatOpenedDateKey);
  }
}
