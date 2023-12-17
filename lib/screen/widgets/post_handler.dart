import 'package:flutter/material.dart';
import 'package:simple_memo_final/database/database_helper.dart';
import 'package:simple_memo_final/data/memo_info.dart';

class PostHandler {
  final BuildContext context;
  final String titleValue;
  final String motiveValue;
  final String contentValue;
  final String feedbackValue;
  final int importanceScore;
  final DatabaseHelper dbHelper;
  MemoInfo? memo;

  PostHandler({
    required this.titleValue,
    required this.motiveValue,
    required this.contentValue,
    required this.feedbackValue,
    required this.importanceScore,
    required this.dbHelper,
    required this.context,
    this.memo,
  });

  Future<void> databaseHandler() async {
    if (titleValue.isEmpty || motiveValue.isEmpty || contentValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("필수로 입력해야 하는 필드입니다!"),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (memo == null) {
      /// 새 게시물 작성
      var memo = MemoInfo(
        title: titleValue,
        motive: motiveValue,
        content: contentValue,
        importance: importanceScore,
        feedback: feedbackValue.isNotEmpty ? feedbackValue : "",
        datetime: DateTime.now().millisecondsSinceEpoch,
      );

      await setInsertMemoInfo(memo);

      if (context.mounted) {
        /// 작성완료 후 이전 화면으로 Direction
        Navigator.pop(context, "insert");
      }
    } else if (memo != null) {
      /// 기존 게시물 수정
      var memoModify = memo;
      memoModify?.title = titleValue;
      memoModify?.motive = motiveValue;
      memoModify?.content = contentValue;
      memoModify?.importance = importanceScore;
      memoModify?.feedback = feedbackValue.isNotEmpty ? feedbackValue : "";

      await setUpdateMemoInfo(memoModify!);

      /// Close current Edit Screen
      if (context.mounted) {
        Navigator.pop(context, "update");
      }
    }
  }

  Future<void> setInsertMemoInfo(MemoInfo memo) async {
    await dbHelper.initDatabase();
    await dbHelper.insertMemoInfo(memo);
  }

  Future<void> setUpdateMemoInfo(MemoInfo memo) async {
    await dbHelper.initDatabase();
    await dbHelper.updateMemoInfo(memo);
  }
}