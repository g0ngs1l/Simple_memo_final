import 'package:flutter/material.dart';
import 'package:simple_memo_final/constants/sizes.dart';
import 'package:simple_memo_final/database/database_helper.dart';
import 'package:simple_memo_final/data/memo_info.dart';
import 'package:simple_memo_final/screen/detail_screen.dart';
import 'package:simple_memo_final/screen/edit_screen.dart';
import 'package:simple_memo_final/screen/widgets/list_item.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper = DatabaseHelper();
  List<MemoInfo> lstMemoInfo = [];

  Future<void> _getMemoInfo() async {
    await dbHelper.initDatabase();
    lstMemoInfo = await dbHelper.getAllMemoInfo();
    lstMemoInfo.sort((a, b) => b.datetime.compareTo(a.datetime));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getMemoInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "SIMPLE NOTE",
          style: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          Sizes.size20,
        ),
        child: ListView.builder(
          itemCount: lstMemoInfo.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                var result = await Navigator.pushNamed(
                  context,
                  DetailScreen.routeName,
                  arguments: lstMemoInfo[index],
                );

                if (result != null) {
                  String msg = "";

                  if (result == "update") {
                    /// 수정 완료
                    msg = "수정이 완료되었습니다.";
                  } else if (result == "delete") {
                    /// 삭제 완료
                    msg = "포스트가 완전히 삭제되었습니다.";
                  }

                  _getMemoInfo();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              child: ListItem(
                lstMemoInfo: lstMemoInfo,
                index: index,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
        onPressed: () async {
          /// 게시글 POST
          var result = await Navigator.pushNamed(context, EditScreen.routeName);

          if (result != null) {
            _getMemoInfo();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("새로운 포스트를 등록하였습니다."),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        },
        child: Image.asset(
          "assets/images/notepad.png",
          width: Sizes.size28,
          height: Sizes.size28,
          color: Colors.white,
        ),
      ),
    );
  }
}