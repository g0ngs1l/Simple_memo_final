import 'package:simple_memo_final/data/memo_info.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/memo_info.dart';

class DatabaseHelper {
  late Database database;

  /// 데이터 베이스 초기화
  Future<void> initDatabase() async {
    /// 데이터 베이스 경로 가져오기
    String path = join(await getDatabasesPath(), "memo.db");

    /// 데이터 베이스 열기/생성
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
          /// 데이터 베이스가 생성될 때 실행되는 코드
          db.execute("""
        CREATE TABLE IF NOT EXISTS tb_memo(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          motive TEXT,
          content TEXT,
          importance INTEGER,
          feedback TEXT,
          datetime INTEGER
        )
      """);
        });
  }

  /// Info 데이터 삽입
  Future<int> insertMemoInfo(MemoInfo memo) async {
    return await database.insert("tb_memo", memo.toMap());
  }

  /// Info 데이터 조회
  Future<List<MemoInfo>> getAllMemoInfo() async {
    final List<Map<String, dynamic>> result = await database.query("tb_memo");
    return List.generate(result.length, (index) {
      return MemoInfo.fromMap(result[index]);
    });
  }

  /// Info 데이터 수정
  Future<int> updateMemoInfo(MemoInfo memo) async {
    return await database.update(
      "tb_memo",
      memo.toMap(),
      where: "id = ?",
      whereArgs: [memo.id],
    );
  }

  /// Info 데이터 삭제
  Future<int> deleteMemoInfo(int id) async {
    return await database.delete(
      "tb_memo",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// 데이터 베이스 닫기(앱 내에서 데이터 베이스를 사용하지 않을 경우 닫아주는 기능)
  Future<void> exitMemoInfo() async {
    await database.close();
  }
}
