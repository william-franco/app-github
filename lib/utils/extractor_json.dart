class Extractor {
  static final Extractor _singleton = new Extractor._internal();
  factory Extractor() {
    return _singleton;
  }
  Extractor._internal();

  static String extractString(value, String defaultValue) {
    return (value != null && value != '') ? value.toString() : defaultValue;
  }

  static double extractDouble(value) {
    try {
      return value != null ? double.parse(value.toString()) : 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  static bool extractBool(value) {
    return value == true ? true : false;
  }

  static double extractHour(time) {
    try {
      var array = time.split(':');

      var hr = int.parse(array[0]);
      var min = (int.parse(array[1]) / 60);

      return (hr + min);
    } catch (e) {
      return null;
    }
  }

  static int extractInt(value) {
    try {
      return value != null ? int.parse(value.toString()) : 0;
    } catch (e) {
      return 0;
    }
  }

}
