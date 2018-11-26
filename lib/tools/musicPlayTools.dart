
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter_app1/config/constConfig.dart';

enum PlayerState {
  playing, paused, stopped
}
typedef void CurrentSongChangedHandler(Map song);

class MusicPlayTools {

  CurrentSongChangedHandler currentSongHandler;

  // 工厂模式
  factory MusicPlayTools() =>_getInstance();
  static MusicPlayTools get instance => _getInstance();
  static MusicPlayTools _instance;
  MusicFinder audioPlayer = new MusicFinder();

  // 音乐列表
  List musicArr = [];
  int currentIndex = 0;
  PlayerState playerState = null;

  void setCurrentSongHandler(CurrentSongChangedHandler handler) {
    currentSongHandler = handler;
  }

  MusicPlayTools._internal() {
    // 初始化
    audioPlayer.setDurationHandler((d) {
      print(d);
    });
    audioPlayer.setStartHandler(() {
      print('StartHandler-------');
    });
    audioPlayer.setCompletionHandler(() {
      print('CompletionHandler-------');
      this.nextMusic();
    });

    audioPlayer.setErrorHandler((msg) {
      print('audioPlayer error : $msg');
      print('ErrorHandler-------');
    });
  }
  static MusicPlayTools _getInstance() {
    if (_instance == null) {
      _instance = new MusicPlayTools._internal();
    }
    return _instance;
  }
  set dataArr(List arr) {
    this.musicArr = arr;
    getIndex().then((index) {
      setCurrentIndex = index;
    });
  }
  // 下表改变
  set setCurrentIndex(int index) {
    this.currentIndex = index;
    this.setIndex();
    // 更新当前歌曲
    if (this.musicArr.length > 0) {
      var song = this.musicArr[this.currentIndex];
      this.currentSongHandler(song);
    }
  }
  // 获取上次存储的下标
  Future<int> getIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt(ConstConfig.CURRENT_INDEX);
    return index;
  }
  // 存储下标
  setIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ConstConfig.CURRENT_INDEX, this.currentIndex);
  }
  // 当前正在播放的音乐
  Map get currentSong {
    if (musicArr.length > 0) {
      return musicArr[currentIndex];
    }
    return {};
  }

  // 播放
  play(Map song) async {
    await stop();
    print(song['songUrl']);
    final result = await audioPlayer.play(song['songUrl']);
    if (result == 1) {
      playerState = PlayerState.playing;
    };
  }
  // 暂停
  pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      playerState = PlayerState.paused;
    };
  }
  // 停止
  stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      playerState = PlayerState.stopped;
    };
  }

  // 下一曲
  nextMusic() {
    this.currentIndex = this.currentIndex + 1;
    if (this.currentIndex > this.musicArr.length) {
      this.currentIndex = 0;
    }
    this.play(this.currentSong);
  }
  // 上一曲
  preMusic() {
    if (this.currentIndex <= 0) {
      this.currentIndex = this.musicArr.length;
    }
    this.currentIndex = this.currentIndex - 1;
    this.play(this.currentSong);
  }
}