class MemoInfo {
  int? id; // 데이터 컬럼 id
  String title; // 제목
  String motive; // 한 줄 요약
  String content; // 내용
  int importance; // 오늘의 점수(1~5)
  String feedback; // 개선 사항
  int datetime; // 글 작성 시간 (년/월/일/시/분)

  // 생성자
  MemoInfo({
    this.id,
    required this.title,
    required this.motive,
    required this.content,
    required this.importance,
    required this.feedback,
    required this.datetime,
  });

  // Map은 key와 value로 이루어진 자료형
  // Info 객체를 Map 객체로 변환
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "motive": motive,
      "content": content,
      "importance": importance,
      "feedback": feedback,
      "datetime": datetime,
    };
  }

  // Map 객체를 Info 데이터 클래스로 변환
  factory MemoInfo.fromMap(Map<String, dynamic> map) {
    return MemoInfo(
      id: map["id"],
      title: map["title"],
      motive: map["motive"],
      content: map["content"],
      importance: map["importance"],
      feedback: map["feedback"],
      datetime: map["datetime"],
    );
  }
}