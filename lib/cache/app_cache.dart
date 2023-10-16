// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/json/user/user_model.dart';

class AppCache {
  static const String ACCESS_TOKEN_PREF = "ACCESS_TOEKN_PREF";

  static const String REFRESH_TOKEN_PREF = "REFRESH_TOEKN_PREF";

  static UserModel? me;

  static Future<void> setInteger(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  static Future<int> getIntegerValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setDouble(String key, double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble(key, value);
  }

  static Future<double> getDoubleValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(key) ?? 0.0;
  }

  static Future<void> setBoolean(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  static Future<bool?> getbooleanValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String data = pref.getString(key) ?? "";
    return data;
  }

  static void setAuthToken(String accessToken, String refreshToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(ACCESS_TOKEN_PREF, accessToken);
    pref.setString(REFRESH_TOKEN_PREF, refreshToken);
  }

  static void removeValues(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(ACCESS_TOKEN_PREF);
  }

  static Future<bool> containValue(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool checkValue = _prefs.containsKey(key);
    return checkValue;
  }

  static Future<bool> setStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, list);
  }

  static Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
}
