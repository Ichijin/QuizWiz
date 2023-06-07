import 'dart:convert';
import 'package:http/http.dart' as http;
import '../settings/googleapi_settings.dart';
/// クイズデータ
class QuizData {
  QuizData({required this.questionNum, required this.question, required this.answer1, required this.answer2, required this.collect});
  final String questionNum; // 設問
  final String question; // 問題
  final String answer1; // 解答１
  final String answer2; // 解答２
  final String collect; // 正解
}
/// クイズデータリポジトリ
class QuizDataRepository {
  /// APIからのデータ取得
  static Future<List<QuizData>> getQuizDataListFromApi() async {
    final List<QuizData> result = [];
    try {
      // レスポンス取得
      final url = GoogleApiSettings.createGoogleSheetsApiGetUrl();
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw ('Failed to Load English Word Data.');
      }
      // 中身のチェック
      final Map<String, dynamic> message = json.decode(res.body);
      if (message['values'] == null) {
        throw ('Please Set English Word Data.');
      }
      // クイズデータとして変換
      final List<dynamic> values = message['values'];
      values.forEach((value) => {
            result.add(
                QuizData(questionNum: value[0], question: value[1], answer1: value[2], answer2: value[3], collect: value[4]))
          });
    } catch (e) {
      print(e); // エラーはログに出力して握りつぶす
    }
    return result;
  }
}