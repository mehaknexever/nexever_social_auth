import 'dart:developer';

class AppLogs {
  static bool showLogs = true;

  logError(
      {required String fileName,
      required String error,
      StackTrace? stackTrace,
      String? text}) {
    if (showLogs) {
      log(text.toString(),
          name: fileName, error: error, stackTrace: stackTrace);
    }
  }
}

extension ErrorLogs on Object {
  logError({required String error, String? text, StackTrace? stackTrace}) {
    AppLogs().logError(
        fileName: runtimeType.toString(),
        error: error,
        stackTrace: stackTrace,
        text: text);
  }
}
