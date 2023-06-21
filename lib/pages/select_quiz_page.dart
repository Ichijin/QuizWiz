import 'package:flutter/material.dart';
import '../components/layout_widgets.dart';
import '../data/quiz_data.dart';

/// 問題の表示状態
enum QuestionDisplayState {
  none,
  ok,
  ng,
  result,
}

/// 単語選択画面
class SelectWordPage extends StatefulWidget {
  final List<QuizData> quizDataList;
//  final bool isOptionShuffle;
  const SelectWordPage(
      {super.key,
      required this.quizDataList,
      //required this.isOptionShuffle
      });
  @override
  State<SelectWordPage> createState() => _SelectWordPageState();
}

class _SelectWordPageState extends State<SelectWordPage> {
  // 英単語データリスト
  List<QuizData> _quizDataList = [];
  // 問題の表示状態
  QuestionDisplayState _questionDisplayState = QuestionDisplayState.none;
  // 問題データ
  QuizData? _questionWordData;
  int _questionIndex = 0;
  int _okAnswerCount = 0;
  // 選択単語リスト
  List<String> _selectWordList = [];
  var isCorrect;
  var ansBool;
  var trueCorrect;
  var ansCorrect;
  var ansComment;
  // 選択単語数
  //static const int selectWordCount = 2;
  /// 単語ボタン押下処理
  void onPressedSelectWordButton(String selectWord) {
    // 答え合わせ
    setState(() {
      ansCorrect = selectWord;
      ansComment = _questionWordData?.comment;
      if (_questionWordData?.collect == '1') {
        isCorrect = selectWord == _questionWordData?.answer1;
        trueCorrect = _questionWordData?.answer1;
      } else if (_questionWordData?.collect == '2') {
        isCorrect = selectWord == _questionWordData?.answer2;
        trueCorrect = _questionWordData?.answer2;
      }
      if (isCorrect) {
        ansBool = 'ok';
        _okAnswerCount++;
      } else {
        ansBool = 'ng';
      }
      _questionDisplayState =
          isCorrect ? QuestionDisplayState.ok : QuestionDisplayState.ng;
    });
  }
  /// NEXTボタン押下処理
  void onPressedNextButton() {
    setState(() {
      // 最後まで問題を出したら結果表示
      ansBool = ''; // 結果の初期化
      _questionIndex++;
      if (_quizDataList.length < _questionIndex) {
        _questionDisplayState = QuestionDisplayState.result;
        return;
      }
      // 次の問題を表示
      createQuestion(_questionIndex);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: displaySelectWordPageWidgetList(),
        ),
      ),
    );
  }
  List<Widget> displaySelectWordPageWidgetList() {
    // 結果表示
    if (_questionDisplayState == QuestionDisplayState.result) {
      return [
        SelectWordResultAreaWidget(
          totalIndex: _quizDataList.length,
          correctCount: _okAnswerCount,
        ),
      ];
    }
    // 問題表示
    return [
      HalfScreenArea(
        child: SelectWordQuestionAreaWidget(
          question: _questionWordData?.question ?? 'empty',
          answer: ansBool.toString(),
          trueAnswer: trueCorrect.toString(),
          ansComment: ansComment.toString(),
          index: _questionIndex + 1,
          totalIndex: _quizDataList.length,
          questionDisplayState: _questionDisplayState,
        ),
      ),
      HalfScreenArea(
        child: SelectWordButtonsAreaWidget(
          selectWordList: _selectWordList,
          isTrueCorrect: trueCorrect.toString(),
          isAnsCorrect: ansCorrect.toString(),
          onPressedSelectWordButton: onPressedSelectWordButton,
          isShowNext: _questionDisplayState == QuestionDisplayState.ok ||
              _questionDisplayState == QuestionDisplayState.ng,
          onPressedNextButton: onPressedNextButton,
        ),
      ),
    ];
  }  @override
  void initState() {
    super.initState();
    // 遷移元からデータを受け取る
    _quizDataList = widget.quizDataList;
    // オプション指定されていたらシャッフルする
//    if (widget.isOptionShuffle) {
//      _QuizDataList.shuffle();
//    }
    // 最初の問題を生成
    _questionIndex = 0;
    _okAnswerCount = 0;
    createQuestion(_questionIndex);
  }
  /// 問題の生成
  void createQuestion(int index) {
    if (index >= _quizDataList.length) {
      _questionDisplayState = QuestionDisplayState.result;
      return;
    }
     _questionDisplayState = QuestionDisplayState.none;
     _questionWordData = _quizDataList[index];
     _selectWordList = [_quizDataList[index].answer1, _quizDataList[index].answer2];
  //       createRandomSelectWordList(_questionWordData?.quizWord ?? 'empty');
  // }
  // /// 単語選択リスト生成
  // List<String> createRandomSelectWordList(String answer) {
  //   // 単語データをコピー
  //   var copyQuizDataList = List.of(_QuizDataList);
  //   copyQuizDataList.shuffle();
  //   // 選択する単語リストを生成
  //   List<String> selectWordList = [];
  //   selectWordList.add(answer);
  //   for (var i = 0; i < copyQuizDataList.length; i++) {
  //     var quizWord = copyQuizDataList[i].quizWord;
  //     // 答えとなる日本語は除く
  //     if (answer == quizWord) {
  //       continue;
  //     }
  //     // 指定数設定したら抜ける
  //     selectWordList.add(quizWord);
  //     if (selectWordList.length >= selectWordCount) {
  //       break;
  //     }
  //   }
  //   selectWordList.shuffle();
  //   return selectWordList;
  }
}

/// 問題文エリア
class SelectWordQuestionAreaWidget extends StatelessWidget {
  final String question;
  final String answer;
  final String trueAnswer;
  final String ansComment;
  final int index;
  final int totalIndex;
  final QuestionDisplayState questionDisplayState;
  const SelectWordQuestionAreaWidget(
      {super.key,
      required this.question,
      required this.answer,
      required this.trueAnswer,
      required this.ansComment,
      required this.index,
      required this.totalIndex,
      required this.questionDisplayState});
  @override
  Widget build(BuildContext context) {
    var ansString = '';
    var strComment = '';
    if (answer == 'ok') {
      ansString = '正解！';
    } else if (answer == 'ng') {
      ansString = '不正解です！'; // 正解は、${trueAnswer} です。';
    }
    if (answer == 'ok' || answer == 'ng') {
      strComment = ansComment;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 問題数
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            '$index / $totalIndex',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  ansString,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.orangeAccent
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  strComment,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Widget getAnsewerWordTextWidget(String answer, QuestionDisplayState state) {
  //   var color = Colors.white;
  //   if (state == QuestionDisplayState.none) {
  //     color = color.withOpacity(0.0);
  //   }
  //   return Text(
  //     answer,
  //     style: TextStyle(
  //       fontSize: 18,
  //       color: color,
  //     ),
  //   );
  // }
  // Widget getAnsewerResultTextWidget(QuestionDisplayState state) {
  //   var message = "";
  //   var color = Colors.black;
  //   switch (state) {
  //     case QuestionDisplayState.ok:
  //       message = "○";
  //       color = Colors.red;
  //       break;
  //     case QuestionDisplayState.ng:
  //       message = "×";
  //       color = Colors.blue;
  //       break;
  //     case QuestionDisplayState.none:
  //     case QuestionDisplayState.result:
  //       break;
  //   }
  //   return SizedBox(
  //     height: 42, // 文字の内容に限らず高さを固定
  //     child: Text(
  //       message,
  //       style: TextStyle(
  //         fontSize: 32,
  //         color: color,
  //       ),
  //     ),
  //   );
  // }
}

/// 単語選択ボタンエリア
class SelectWordButtonsAreaWidget extends StatelessWidget {
  final List<String> selectWordList;
  final String isTrueCorrect;
  final String isAnsCorrect;
  final Function onPressedSelectWordButton;
  final bool isShowNext;
  final Function onPressedNextButton;
  const SelectWordButtonsAreaWidget(
      {super.key,
      required this.selectWordList,
      required this.isTrueCorrect,
      required this.isAnsCorrect,
      required this.onPressedSelectWordButton,
      required this.isShowNext,
      required this.onPressedNextButton});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // 単語選択ボタン群
      Expanded(
        flex: 5,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          padding: const EdgeInsets.all(20.0),
          childAspectRatio: 2.5,
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          children: selectWordList
              .map((selectWord) => SelectWordButtonWidget(
                    text: selectWord,
                    trueText: isTrueCorrect,
                    ansText: isAnsCorrect,
                    onPressed: isShowNext ? null : onPressedSelectWordButton,
                  ))
              .toList(),
        ),
      ),
      // NEXTボタン
      if (isShowNext)
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 48),
              child: TextButton(
                onPressed: () => onPressedNextButton(),
                child: Text(
                  'NEXT ▶︎',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
/// 単語選択ボタン
class SelectWordButtonWidget extends StatelessWidget {
  final String text;
  final String trueText;
  final String ansText;
  final Function? onPressed;
  const SelectWordButtonWidget(
      {super.key, required this.text, required this.trueText, required this.ansText, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    var textStr = text;
    if (onPressed == null) {
      textStr = text == ansText? text: '';
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        foregroundColor: Theme.of(context).backgroundColor,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: onPressed == null ? null : () => onPressed!(text),
      child: Text(textStr),
    );
  }
}

/// 結果表示
class SelectWordResultAreaWidget extends StatelessWidget {
  final int totalIndex;
  final int correctCount;
  const SelectWordResultAreaWidget(
      {super.key, required this.totalIndex, required this.correctCount});
  @override
  Widget build(BuildContext context) {
    var imageStr;
    if (correctCount == totalIndex) {
      imageStr = 'images/finish.png';
    } else {
      imageStr = 'images/robot.png';
    }
    return Center(
      child: Column(
        children: [
          Text(
            '正解数: $correctCount / $totalIndex',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(imageStr),
          const SizedBox(height: 20),
          SizedBox(
            width: 120,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                foregroundColor: Theme.of(context).backgroundColor,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BACK'),
            ),
          ),
        ],
      ),
    );
  }
}