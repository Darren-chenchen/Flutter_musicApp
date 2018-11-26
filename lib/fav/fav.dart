import 'package:flutter/material.dart';
import 'package:flutter_app1/tools/favTools.dart';
import 'package:flutter_app1/api/httpUtil.dart';
import 'package:flutter_app1/tools/musicPlayTools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Fav extends StatefulWidget {
  @override
  FavState createState() => new FavState();
}

class FavState extends State<Fav> with AutomaticKeepAliveClientMixin {

  List _dataArr = [];
  List _saved = [];
  FavTools _favTool = FavTools.instance;
  MusicPlayTools _musicTool = MusicPlayTools.instance;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadData();
  }

  _loadData() async {
    String dataURL = "api/songList";
    var util = HttpUtil();
    util.options.baseUrl = 'http://oldmusic.darrenblog.club/';
    var response = await util.post(dataURL, data: {});
    setState(() {
      _dataArr = response.data['data'];
    });
    reloadFav();
  }

  Widget _setupLoading() {
    return new Center(
      child: new SpinKitFadingCircle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("经典老歌"),
        centerTitle: true,
      ),
      body: _dataArr.length > 0? _setupListView():_setupLoading(),
    );
  }

  // 刷新收藏
  reloadFav() {
    _favTool.getFavList().then((value) {
      setState(() {
        _saved = value;
      });
    });
  }

  Widget _setupListView() {
    return new ListView.builder(
        itemCount: _dataArr.length,
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider(color: Colors.black);

          if (_dataArr.length > 0) {
            return _getRow(_dataArr[i]);
          }
        });
  }

  Widget _getRow(Map rowData) {
    var arr = (_saved ?? []).where((ele) => ele['_id'] == rowData['_id']);
    var alreadySaved = (arr.length > 0);

    return new GestureDetector(
      onTap: () {
        _musicTool.dataArr = _dataArr;
        _musicTool.play(rowData);
        var index = this._dataArr.indexOf(rowData);
        _musicTool.setCurrentIndex = index;
      },
      child: new Container(
        height: 60,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: new Container(child: new Text(rowData['title'],style: new TextStyle(color: Colors.white),),)
            ),
            new Container(
              child: new IconButton(
                icon: (alreadySaved
                    ? new Icon(Icons.favorite)
                    : Icon(Icons.favorite_border)),
                color: alreadySaved ? Colors.red : null,
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _favTool.delectFavData(rowData['_id']).then((success) {
                        reloadFav();
                      });
                    } else {
                      // 加入数据库
                      _favTool.saveFavData(rowData).then((success) {
                        reloadFav();
                      });
                    }
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}