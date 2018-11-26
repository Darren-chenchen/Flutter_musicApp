import 'package:flutter/material.dart';
import 'package:flutter_app1/api/httpUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app1/tools/userTools.dart';

typedef void RegiestPageSuccessCallBack();

class RegiestPage extends StatefulWidget {

  RegiestPageSuccessCallBack successCallBack;
  void setSuccessCallBackHandler(RegiestPageSuccessCallBack handler) {
    successCallBack = handler;
  }
  @override
  RegiestPageState createState() => new RegiestPageState();
}

class RegiestPageState extends State<RegiestPage> {

  UserTools _userTools = UserTools.instance;
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerPwd = new TextEditingController();

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
        onPressed: () {
          _goRegiest();
        },
        child: new Text('注 册', style: new TextStyle(color: Colors.white),),
      ))
    ],);
  }

  _goRegiest() async {
    String dataURL = "api/user/register";
    var response = await HttpUtil().post(dataURL, data: {'userName': _controller.text, 'passWord': _controllerPwd.text});
    print(response);
    if (response.data['success'] == true) {
      // 存储用户信息
      _userTools.setUserData(response.data['data']);

      widget.successCallBack();
      Fluttertoast.showToast(
          msg: response.data['message']
      );
    } else {
      Fluttertoast.showToast(
          msg: response.data['message']
      );
    }
  }
}