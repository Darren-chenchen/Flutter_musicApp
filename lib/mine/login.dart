import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'regiestPage.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  String _navTitle = '登录';
  RegiestPage _regiestPage = RegiestPage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _regiestPage.setSuccessCallBackHandler(() {
      this._scrollPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_navTitle),
          centerTitle: true,
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: _setupContent(),
              ),
              _setupBottom()
            ],
          ),
        ));
  }

  Widget _setupPage(int i) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: new Container(
        child: i == 0 ? _setupLoginWrapper() : _setupRegiestWrapper(),
      ),
    );
  }

//  登录界面
  Widget _setupLoginWrapper() {
    return LoginPage();
  }

//  注册界面
  Widget _setupRegiestWrapper() {
    return _regiestPage;
  }

//  PageView
  Widget _setupContent() {
    return new Container(
      height: 400,
      child: new PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (context, i) {
            return _setupPage(i);
          }),
    );
  }

  _scrollPage() {
    if (_currentPage == 0) {
      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage = 1;
        _navTitle = '注册';
      });

    } else {
      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPage = 0;
        _navTitle = '登录';
      });
    }
  }

  Widget _setupBottom() {
    return new Container(
      height: 50,
      alignment: Alignment.center,
      child: new Center(
          child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(_currentPage == 0? '没有账号？':'已有账号', style: TextStyle(color: Colors.white)),
          new GestureDetector(
            onTap: () {
              _scrollPage();
            },
            child:  new Text(
              _currentPage == 0? '快速注册':'立即登录',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          new Icon(
            Icons.arrow_right,
            color: Colors.blue,
          )
        ],
      )),
    );
  }
}
