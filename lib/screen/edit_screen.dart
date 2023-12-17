import 'package:flutter/material.dart';
import 'package:simple_memo_final/constants/gaps.dart';
import 'package:simple_memo_final/constants/sizes.dart';
import 'package:simple_memo_final/database/database_helper.dart';
import 'package:simple_memo_final/data/memo_info.dart';
import 'package:simple_memo_final/screen/widgets/confirm_button.dart';
import 'package:simple_memo_final/screen/widgets/importance_button.dart';
import 'package:simple_memo_final/screen/widgets/post_handler.dart';
import 'package:simple_memo_final/screen/widgets/text_field_controller.dart';

//ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  static String routeName = "/edit";

  MemoInfo? memo;

  EditScreen({
    super.key,
    this.memo,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  /// 제목 입력 필드
  final TextEditingController _titleController = TextEditingController();

  /// 한 줄 요약 입력 필드
  final TextEditingController _motiveController = TextEditingController();

  /// 내용 입력 필드
  final TextEditingController _contentController = TextEditingController();

  /// 개선 사항 입력 필드
  final TextEditingController _feedbackController = TextEditingController();

  /// Importance Statement
  bool isClicked01 = false;
  bool isClicked02 = false;
  bool isClicked03 = true;
  bool isClicked04 = false;
  bool isClicked05 = false;
  int importanceScore = 3;

  /// Database Handling
  final dbHelper = DatabaseHelper();

  /// 뒤로가기
  void _onBack() {
    Navigator.pop(context);
  }

  /// 화면 터치, 키보드 비활성화
  void _keyBoardUnFocus() {
    FocusScope.of(context).unfocus();
  }

  /// 점수 선택값 (Boolean) 초기화
  void _initClickStatus() {
    isClicked01 = false;
    isClicked02 = false;
    isClicked03 = false;
    isClicked04 = false;
    isClicked05 = false;
  }

  /// Import Database Handling Class
  Future<void> _editComplete() async {
    PostHandler postHandler = PostHandler(
      context: context,
      titleValue: _titleController.text.toString(),
      motiveValue: _motiveController.text.toString(),
      contentValue: _contentController.text.toString(),
      feedbackValue: _feedbackController.text.toString(),
      importanceScore: importanceScore,
      dbHelper: dbHelper,
      memo: widget.memo,
    );

    await postHandler.databaseHandler();
  }

  @override
  void initState() {
    super.initState();

    _titleController;
    _motiveController;
    _contentController;
    _feedbackController;

    /// 게시글 수정 사항 세팅
    if (widget.memo != null) {
      _titleController.text = widget.memo!.title;
      _motiveController.text = widget.memo!.motive;
      _contentController.text = widget.memo!.content;

      if (widget.memo!.feedback.isNotEmpty) {
        _feedbackController.text = widget.memo!.feedback;
      }

      _initClickStatus();
      switch (widget.memo!.importance) {
        case 1:
          isClicked01 = true;
          break;
        case 2:
          isClicked02 = true;
          break;
        case 3:
          isClicked03 = true;
          break;
        case 4:
          isClicked04 = true;
          break;
        case 5:
          isClicked05 = true;
          break;
      }

      importanceScore = widget.memo!.importance;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _motiveController.dispose();
    _contentController.dispose();
    _feedbackController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _onBack,
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: Sizes.size24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.memo == null ?  "새 글 작성하기" : "글 수정하기",
          style: const TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _keyBoardUnFocus,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.size20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title
                const Text(
                  "제목",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldController(
                  height: Sizes.size42,
                  vertical: 0,
                  horizontal: Sizes.size20,
                  controller: _titleController,
                  hintText: "제목을 작성해 주세요.",
                  textInputAction: TextInputAction.next,
                ),
                Gaps.v24,

                /// motive
                const Text(
                  "오늘 하루 한 줄 요약",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldController(
                  height: Sizes.size42,
                  vertical: 0,
                  horizontal: Sizes.size20,
                  controller: _motiveController,
                  hintText: "오늘의 근무는 어땠나요?",
                  textInputAction: TextInputAction.next,
                ),
                Gaps.v24,

                /// content
                const Text(
                  "근무 기록",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFieldController(
                  controller: _contentController,
                  vertical: Sizes.size20,
                  horizontal: Sizes.size20,
                  hintText: "오늘 근무 중 있었던 일을 기록해봅시다.",
                  maxLines: 10,
                  maxLength: 1000,
                ),
                Gaps.v24,

                /// importance
                const Text(
                  "오늘의 점수",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _initClickStatus();

                        setState(() {
                          importanceScore = 1;
                          isClicked01 = true;
                        });
                      },
                      child: ImportanceButton(
                        score: 1,
                        isClicked: isClicked01,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _initClickStatus();

                        setState(() {
                          importanceScore = 2;
                          isClicked02 = true;
                        });
                      },
                      child: ImportanceButton(
                        score: 2,
                        isClicked: isClicked02,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _initClickStatus();

                        setState(() {
                          importanceScore = 3;
                          isClicked03 = true;
                        });
                      },
                      child: ImportanceButton(
                        score: 3,
                        isClicked: isClicked03,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _initClickStatus();

                        setState(() {
                          importanceScore = 4;
                          isClicked04 = true;
                        });
                      },
                      child: ImportanceButton(
                        score: 4,
                        isClicked: isClicked04,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _initClickStatus();

                        setState(() {
                          importanceScore = 5;
                          isClicked05 = true;
                        });
                      },
                      child: ImportanceButton(
                        score: 5,
                        isClicked: isClicked05,
                      ),
                    ),
                  ],
                ),
                Gaps.v24,

                /// feedback
                const Text("개선할 점 (선택)"),
                TextFieldController(
                  controller: _feedbackController,
                  vertical: Sizes.size20,
                  horizontal: Sizes.size20,
                  hintText: "떠오른 아이디어를 기반으로 전달받은\n피드백을 정리해 주세요.",
                  maxLines: 5,
                  maxLength: 500,
                ),

                /// 작성 완료 버튼
                GestureDetector(
                  onTap: _editComplete,
                  child: ConfirmButton(
                    text: widget.memo == null ? "작성완료" : "수정완료",
                    margin: const EdgeInsets.only(
                      top: Sizes.size24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
