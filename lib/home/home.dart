import 'package:flutter/material.dart';
import 'package:flutter_app1/api/httpUtil.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_app1/tools/favTools.dart';
import 'package:flutter_app1/tools/musicPlayTools.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List _suggestions = [];
  List _saved = [];
  FavTools _favTool = FavTools.instance;
  MusicPlayTools _musicTool = MusicPlayTools.instance;
  Map _currentSong = {};

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reloadFav();

    loadData();

    _musicTool.setCurrentSongHandler((song) {
      setState(() {
        _currentSong = song;
      });
    });
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    print('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  // 刷新收藏
  reloadFav() {
    _favTool.getFavList().then((value) {
      setState(() {
        _saved = value;
      });
    });
  }

  void _pushSaved() {
    Navigator.of(context).pushNamed('/search');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('流行歌曲'),
//        leading: new IconButton(icon: new Icon(Icons.settings), onPressed: _pushSaved),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: _pushSaved),
        ],
      ),
      body: _suggestions.length > 0? _setupBody():_setupLoading(),
    );
  }

  Widget _setupBody() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Expanded(child: _buildSuggestions()),
          _setupBottom()
        ],
      ),
    );
  }

  Widget _setupLoading() {
    return new Center(
      child: new SpinKitFadingCircle(
        color: Colors.white,
      ),
    );
  }

  padNum(String pad) {
    var num = '${(double.parse(pad) / 60).toInt()}';
    var len = num.toString().length;
    while (len < 2) {
      num = '0' + num;
      len++;
    }
    return num;
  }

  dealDuration(String duration) {
    return padNum(duration) + ':${(double.parse(duration) % 60).toInt()}';
  }

  Widget getRow(Map rowData) {
    var arr = (_saved ?? []).where((ele) => ele['_id'] == rowData['_id']);
    var alreadySaved = (arr.length > 0);

    return new GestureDetector(
        onTap: () {
          _musicTool.dataArr = _suggestions;
          //处理点击事件
          _musicTool.play(rowData);
          var index = this._suggestions.indexOf(rowData);
          _musicTool.setCurrentIndex = index;
        },
        child: new Container(
          color: Colors.transparent,
          padding: new EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: new Row(
            children: <Widget>[
              new Container(
                width: 60,
                height: 60,
                child: FadeInImage.assetNetwork(
                  image: rowData['imgUrl'],
                  placeholder: 'images/placehoder_img.png',
                  fit: BoxFit.cover,
                ),
              ),
              new Expanded(
                  child: new Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.fromLTRB(10, 5, 0, 0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          rowData['title'],
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.title,
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: new Row(
                            children: <Widget>[
                              new Image.asset(
                                'images/timer.png',
                                width: 15,
                                height: 15,
                              ),
                              new Text(
                                dealDuration(rowData['duration']),
                                textAlign: TextAlign.left,
                                style:
                                new TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
        )
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          if (_suggestions.length > 0) {
            return getRow(_suggestions[i]);
          }
        });
  }

  Widget _setupBottom() {
    return new Container(
      height: 50,
      child: new Column(
        children: <Widget>[
          new Container(
            height: 50,
            child: new Row(
              children: <Widget>[
                FadeInImage.assetNetwork(
                  width: 50,
                  height: 50,
                  image: _currentSong['imgUrl'] ?? '',
                  placeholder: 'images/placehoder_img.png',
                  fit: BoxFit.cover,
                ),
                new Expanded(
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: new Text(
                        _currentSong['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    )),
                new IconButton(icon: new Icon(Icons.pause,color: Theme.of(context).iconTheme.color,), onPressed: null),
                new IconButton(icon: new Icon(Icons.skip_next, color: Theme.of(context).iconTheme.color), onPressed: null)
              ],
            ),
          )
        ],
      ),
    );
  }

  loadData() async {
    String dataURL = "api/songList";
    var response = await HttpUtil().post(dataURL, data: {});
    setState(() {
      _suggestions = response.data['data'];
    });
    reloadFav();
  }
}
