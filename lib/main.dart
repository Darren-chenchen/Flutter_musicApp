import 'package:flutter/material.dart';
import 'package:flutter_app1/main/app.dart';
import 'home/search.dart';
import 'mine/login.dart';

void main() => runApp(new MaterialApp(
  home: new App(),
  routes: <String, WidgetBuilder>{
    '/search': (BuildContext context) => new Search(),
    '/login': (BuildContext context) => new Login(),
  },
  theme: new ThemeData(
      highlightColor: Colors.transparent,   //将点击高亮色设为透明
      splashColor: Colors.transparent,    //将喷溅颜色设为透明
      bottomAppBarColor: new Color.fromRGBO(19, 35, 63, 1), //设置底部导航的背景色
      scaffoldBackgroundColor:new Color.fromRGBO(19, 35, 63, 1), //设置页面背景颜色
      primaryColor: new Color.fromRGBO(19, 35, 63, 1),
      backgroundColor: new Color.fromRGBO(19, 35, 63, 1),
      indicatorColor: new Color.fromRGBO(19, 35, 63, 1),    //设置tab指示器颜色

      primaryIconTheme: new IconThemeData(color: Colors.white),//主要icon样式，如头部返回icon按钮
      iconTheme: new IconThemeData(size: 18.0, color: Colors.white),   //设置icon样式

      textTheme: new TextTheme(
          title: new TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal
          ),
          subtitle: new TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal
          )
      ),
      primaryTextTheme: new TextTheme( //设置文本样式
          title: new TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold)),

      tabBarTheme: new TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey)
  ),
));