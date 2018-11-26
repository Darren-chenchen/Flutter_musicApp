import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "Fav";
final String columnId = "_id";
final String columnTitle = "title";
final String columnImgUrl = "imgUrl";
final String columnSinger = "singer";
final String columnSongUrl = "songUrl";
final String columnDuration = "duration";

class Todo {
  String _id;
  String title;
  String imgUrl;
  String singer;
  String songUrl;
  String duration;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnId: _id,
      columnImgUrl: imgUrl,
      columnSinger: singer,
      columnSongUrl: songUrl,
      columnDuration: duration
    };
    return map;
  }

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    _id = map[columnId];
    title = map[columnTitle];
    imgUrl = map['imgUrl'];
    singer = map['singer'];
    songUrl = map['songUrl'];
    duration = map['duration'];
  }
}

class FavTools {

  static FavTools instance = FavTools();

  static Database db;

  Future<String> getPath(String db) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, db);
    return path;
  }

  Future<Database> initDb() async {
    String path = await getPath("fav.db");
    if (db == null) {
      db = await openDatabase(path);

      if (db.isOpen) {
        print('数据库打开成功');
        // 判断有没有创建数据库
//        if (await new Directory(dirname(path)).exists()) {
//          print('数据库已经存在');
//        } else {
          await db.execute('''
create table $tableName ( 
  $columnId text not null, 
  $columnTitle text not null,
  $columnImgUrl text,
  $columnSinger text,
  $columnSongUrl text not null,
  $columnDuration text
  )
''');
          print('创建表成功');
//        }
      } else {
        print('数据库打开失败');
      }
    } else {
      if (db.isOpen == false) {
        print('数据库再次打开');
        db = await openDatabase(path);
      }
    }
  }

  // 获取数据
  Future<List> getFavList() async {
    await initDb();
    var result = await db.rawQuery('SELECT * FROM $tableName');
    await close();
    return result;
  }

  // 存收藏数据
  Future<int> saveFavData(Map favData) async {
    await initDb();
    var todo = Todo.fromMap(favData);
    var result = await db.insert(tableName, todo.toMap());
    await close();
    return result;
  }

  // 删除数据
  Future<int> delectFavData(String id) async {
    await initDb();
    var result = await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
    await close();
    return result;
  }

  Future<int> update(Map favData) async {
    await initDb();
    var todo = Todo.fromMap(favData);
    var result = await db.update(tableName, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo._id]);
    await close();
    return result;
  }

  Future close() async => db.close();
}