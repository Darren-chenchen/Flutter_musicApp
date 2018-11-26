import 'package:flutter/material.dart';
import 'package:flutter_app1/tools/userTools.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerPwd = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserTools.instance.getUserData().then((user) {
      if (user["userName"]) {
        _controller.text = user["userName"];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: EdgeInsets.fromLTRB(35, 60, 35, 0),
      child: new Column(
        children: <Widget>[
          _setupMail(),
          _setupPwd(),
          _setupLogin()
        ],
      ),
    );
  }

  Widget _setupMail() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Icon(Icons.email, color: Colors.white),
              new Expanded(child: new Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextField(
                  style: new TextStyle(color: Colors.white),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "请输入邮箱",
                    hintStyle: new TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none
                  ),
                ),
              ))
            ],
          ),
          new Divider(color: Colors.grey,)
        ],
      ),
    );
  }

  Widget _setupPwd() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Icon(Icons.lock, color: Colors.white),
              new Expanded(child: new Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextField(
                  style: new TextStyle(color: Colors.white),
                  controller: _controllerPwd,
                  decoration: InputDecoration(
                      hintText: "请输入密码",
                      hintStyle: new TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                  ),
                ),
              ))
            ],
          ),
          new Divider(color: Colors.grey,)
        ],
      ),
    );
  }

  Widget _setupLogin() {
    return new Row(children: <Widget>[
      new Expanded(child: new RaisedButton(
          onPressed: null,
          child: new Text('登 录', style: new TextStyle(color: Colors.white),),
      ))
    ],);
  }
}