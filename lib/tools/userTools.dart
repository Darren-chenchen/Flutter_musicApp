import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app1/config/constConfig.dart';
import 'dart:convert';

class UserTools {

  static UserTools instance = UserTools();

  // 存储用户数据
  setUserData(Map user) async {
    var jsonStr = "$user";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ConstConfig.CURRENT_USERDATA, jsonStr);
    print(jsonStr);
  }

  // 获取数据
  Future<Map> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mapStr = prefs.getString(ConstConfig.CURRENT_USERDATA);
    var map = json.decode(mapStr);
    print(map);
    return map;
  }

  // 删除数据
  delectUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ConstConfig.CURRENT_USERDATA, '');
  }
}