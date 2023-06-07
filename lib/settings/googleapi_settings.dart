class GoogleApiSettings {
  // この辺は各自設定してください
  static const String spreadsSheetsUrl = "1752AvRzYh8TS7qFPONU-L4Oj9DGVifAVK-tc5lj39aA";
  static const String sheetName = "Quiz10";
  static const String apiKey = "AIzaSyBiIE520hByHAMRr7qQKX59jhN6A6Tw2I8";
  /// GoogleSheetsAPI(v4.spreadsheets.values - get)のURL生成
  /// 詳細: https://developers.google.com/sheets/api/reference/rest
  static String createGoogleSheetsApiGetUrl() {
    if (spreadsSheetsUrl.isEmpty || sheetName.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/${spreadsSheetsUrl}/values/${sheetName}?key=${apiKey}';
  }
}