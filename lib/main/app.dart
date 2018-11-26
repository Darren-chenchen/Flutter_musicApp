import 'package:flutter/material.dart';
import 'package:flutter_app1/home/home.dart';
import 'package:flutter_app1/fav/fav.dart';
import 'package:flutter_app1/mine/mine.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => new AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {

  TabController controller;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ontap(int index) {
    setState(() {
      _currentIndex = index;
    });
    controller.animateTo(index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          new Home(),
          new Fav(),
          new Mine(),
        ],
      ),
      bottomNavigationBar: Theme(data: new ThemeData(
        canvasColor: new Color.fromRGBO(19, 35, 63, 1), // BottomNavigationBar背景色
        textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle(color: Colors.grey))
      ),
      child: BottomNavigationBar(
          fixedColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: ontap,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.music_video),
                title: new Text('POP')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.music_note),
                title: new Text('OLD')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.people),
                title: new Text('我的'))
          ]))
    );
  }
}



//      bottomNavigationBar: new Material(
//        color: new Color.fromRGBO(19, 35, 63, 1),
//        child: new TabBar(
//          isScrollable: false,
//          indicatorWeight: 0.1,
//          controller: controller,
//          tabs: [
//            new Tab(
//              text: 'POP',
//              icon: new Icon(
//                Icons.music_video,
//              ),
//            ),
//            new Tab(
//              text: 'OLD',
//              icon: new Icon(
//                Icons.music_note,
//              ),
//            ),
//            new Tab(
//              text: '我的',
//              icon: new Icon(
//                Icons.people,
//              ),
//            ),
//          ],
//        ),
//      ),
