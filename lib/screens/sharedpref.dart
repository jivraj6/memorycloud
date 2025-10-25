import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String? _userId;
  static String? _userName;
  static String? _userMobile;
  static int? _userStatus;

  static Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _userId = prefs.getString('user_id');
    _userName = prefs.getString('user_name');
    _userMobile = prefs.getString('user_mobile');
    _userStatus = prefs.getInt('user_status');
  }

  // ---------------- Save individual fields ----------------
  static Future<void> setUserId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = id;
    await prefs.setString('user_id', id);
  }

  static Future<void> setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = name;
    await prefs.setString('user_name', name);
  }

  static Future<void> setUserMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userMobile = mobile;
    await prefs.setString('user_mobile', mobile);
  }

  static Future<void> setUserStatus(int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userStatus = status;
    await prefs.setInt('user_status', status);
  }

  // ---------------- Get individual fields ----------------
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<String?> getUserMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_mobile');
  }

  static Future<int?> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_status');
  }

  static String? get userId => _userId;
  static String? get userName => _userName;

  static String? get userMobile => _userMobile;

  static int? get userStatus => _userStatus;

  // ---------------- Logout / Clear all ----------------
  static Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _userId = null;
    _userName = null;
    _userMobile = null;
    _userStatus = null;
  }
}
