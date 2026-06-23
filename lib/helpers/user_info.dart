import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  Future setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("token", value);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  Future setUserID(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setInt("userID", value);
  }

  Future<int?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  Future setRole(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("role", value);
  }

  Future<String?> getRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("role");
  }

  Future setFullname(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString("fullname", value);
  }

  Future<String?> getFullname() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("fullname");
  }

  Future logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  // Cek apakah onboarding sudah pernah dilihat
  Future setOnboardingSeen() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool("onboarding_seen", true);
  }

  Future<bool> getOnboardingSeen() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("onboarding_seen") ?? false;
  }
}