import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<Search> {
  List _historyList = [];
  List _hotList = [];
  Dio dio = new Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadHotKeyData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("搜索"),
      ),
      body: new ListView(
        children: <Widget>[
          new Column(
            children: <Widget>[
              _setupSearchTop(),
              _setupSearchHistory(),
              _setupSearchHot()
            ],
          ),
        ],
      )
    );
  }

  List<Container> _buildGridTileList(int count) {
    return new List<Container>.generate(
        count,
            (int index) =>
    _getRow(_historyList[index]));
  }

  List<Container> _buildHotList(int count) {
    return new List<Container>.generate(
        count,
            (int index) =>
            _getRow(_hotList[index]));
  }

  Widget _setupWrapView(bool isHotKey) {
    return new Wrap(
        spacing: 10.0,
        runSpacing: 18.0,
        children: isHotKey? _buildHotList(_hotList.length):_buildGridTileList(_historyList.length));
  }

  Widget _setupHeader(bool isHotKey) {
    return new Container(
      height: 44,
      padding: EdgeInsets.fromLTRB(12, 0, 10, 0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(isHotKey? '热门搜索':'历史搜索',
                style: new TextStyle(
                    color: Theme.of(context).textTheme.subtitle.color,
                    fontSize:
                    Theme.of(context).textTheme.subtitle.fontSize)),
          ),
          new Container(
            width: 50,
            child: isHotKey ? null:new Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  Widget _getRow(Map key) {
    return new Container(
      height: 30,
      margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          )
      ),
      child: new Text(key['word'], style: new TextStyle(color: Colors.grey),),
    );
  }
  // 顶部
  Widget _setupSearchTop() {
    return new Container(
        margin: EdgeInsets.all(10),
        child: new Material(
          borderRadius: BorderRadius.circular(6.0),
          color: Color.fromRGBO(15, 24, 43, 1),
          child: new Container(
            padding: EdgeInsets.all(10),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.search),
                new Text(
                  '搜索',
                  style: new TextStyle(
                      color: Theme.of(context).textTheme.subtitle.color),
                )
              ],
            ),
          ),
        ));
  }

  // 历史搜索
  Widget _setupSearchHistory() {
    return new Container(
      child: new Column(
        children: <Widget>[
          _historyList.length > 0 ? _setupHeader(false):new Container(),
          new Container(
            child: _setupWrapView(false),
          ),
        ],
      ),
    );
  }

  // 热门搜索
  Widget _setupSearchHot() {
    return new Container(
      child: new Column(
        children: <Widget>[
          _hotList.length > 0 ? _setupHeader(true):new Container(),
          new Container(
            child: _setupWrapView(true),
          ),
        ],
      ),
    );
  }

  loadHotKeyData() async {
    Response response = await dio.get("http://tingapi.ting.baidu.com/v1/restserver/ting?from=android&version=5.6.5.6&format=json&method=baidu.ting.search.hot");
    setState(() {
      _hotList = response.data['result'];
    });
  }
}
