class JsonCleaner {
  static String clean(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');

    if (start == -1 || end == -1) {
      return text;
    }

    return text.substring(start, end + 1);
  }
}