class Log {
  static void d(String text) => print("\x1B[34m$text\x1B[0m");
  static void e(String text) => print("\x1B[31m$text\x1B[0m");
  static void i(String text) => print("\x1B[33m$text\x1B[0m");
}