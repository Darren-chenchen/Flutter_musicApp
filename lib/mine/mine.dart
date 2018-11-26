import 'package:flutter/material.dart';

class Mine extends StatefulWidget {
  @override
  MineState createState() => new MineState();
}

class MineState extends State<Mine> with AutomaticKeepAliveClientMixin {

  List _contentArr = ['我的收藏', '意见反馈', '关于软件', '五星好评'];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new ListView(
          children: <Widget>[
            _setupHeader(),
            _setupBody()
          ],
        )
    );
  }

  _gotoLogin() {
    Navigator.of(context).pushNamed('/login');
  }

  Widget _setupHeader() {
    return new Container(
      height: 300,
      child: new Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
            new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.asset('images/placehoder_img.png', fit: BoxFit.cover,),
              ],
            ),
            new GestureDetector(
              onTap: () {
                _gotoLogin();
              },
              child: new Container(
                  width: 120,
                  height: 120,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.0)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      )
                  ),
                  child: new CircleAvatar(
                    backgroundImage: new AssetImage('images/placehoder_img.png'),
                    radius: 60.0,
                  )
              ),
            ),
            new GestureDetector(
              onTap: () {
                _gotoLogin();
              },
              child: new Text('未登录', style: new TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            )

      ],
      ),
    );
  }

  List<Container> _buildList(int count) {
    return new List<Container>.generate(
        count,
            (int index) =>
            _getRow(_contentArr[index]));
  }

  ontap(String row) {
    print(row);
  }

  _getRow(String row) {
    return new Container(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        height: 44,
        child: new GestureDetector(
          onTap: () {
            this.ontap(row);
          },
          child: new Column(children: <Widget>[
            new Container(
              height: 43,
              child: new Row(
                children: <Widget>[
                  new Expanded(child: new Text(row, style: new TextStyle(color: Colors.white),)),
                  new Container(
                    width: 50,
                    child: new Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ),
            new Container(
              height: 1,
              color: new Color.fromRGBO(0, 0, 0, 0.3),
            )
          ],),
        )
    );
  }

  Widget _setupBody() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: new Wrap(
        children: _buildList(_contentArr.length)
      ),
    );
  }
}