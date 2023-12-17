import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_memo_final/constants/gaps.dart';
import 'package:simple_memo_final/constants/sizes.dart';
import 'package:simple_memo_final/database/database_helper.dart';
import 'package:simple_memo_final/data/memo_info.dart';
import 'package:simple_memo_final/screen/edit_screen.dart';
import 'package:simple_memo_final/screen/widgets/confirm_button.dart';

class DetailScreen extends StatelessWidget {
  static String routeName = "/detail";

  MemoInfo? memo;

  DetailScreen({super.key, this.memo});

  final dbHelper = DatabaseHelper();

  Future<void> _setDeleteMemoInfo(int id) async {
    await dbHelper.initDatabase();
    await dbHelper.deleteMemoInfo(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: Sizes.size24,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              /// Delete Process
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("주의"),
                      content: const Text("이 포스트를 삭제할까요?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _setDeleteMemoInfo(memo!.id!);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.pop(context, "delete");
                            }
                          },
                          child: const Text(
                            "확인",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: const Text(
              "삭제",
              style: TextStyle(
                color: Colors.red,
                fontSize: Sizes.size16,
              ),
            ),
          ),
        ],
        title: Text(
          memo!.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(
                  Sizes.size20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// motive
                    const Text(
                      "오늘 하루 한 줄 요약",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      memo!.motive,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Gaps.v28,

                    /// content
                    const Text(
                      "근무 기록",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      memo!.content,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Gaps.v28,

                    /// importance
                    const Text(
                      "오늘의 점수",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    RatingBar.builder(
                      initialRating: memo!.importance.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: Sizes.size34,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      ignoreGestures: true,
                      updateOnDrag: false,
                      itemBuilder: (BuildContext context, int index) {
                        return const FaIcon(
                          FontAwesomeIcons.star,
                          color: Colors.amberAccent,
                        );
                      },
                      onRatingUpdate: (double value) {},
                    ),
                    Gaps.v28,

                    /// feedback
                    const Text(
                      "개선할 점",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      memo!.feedback,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Edit Button
          GestureDetector(
            onTap: () async {
              var result = await Navigator.pushNamed(
                context,
                EditScreen.routeName,
                arguments: memo,
              );

              if (result != null) {
                if (context.mounted) {
                  Navigator.pop(context, "update");
                }
              }
            },
            child: const ConfirmButton(
              text: "수정하기",
              margin: EdgeInsets.symmetric(
                vertical: Sizes.size16,
                horizontal: Sizes.size16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}