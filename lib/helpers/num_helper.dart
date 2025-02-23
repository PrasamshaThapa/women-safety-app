class NumHelper {
  static num? parseString(String? value) {
    int? intValue = int.tryParse(value ?? '0');
    if (intValue != null) {
      return intValue;
    }

    double? doubleValue = double.tryParse(value ?? '0');
    if (doubleValue != null) {
      return doubleValue;
    }
    return null;
  }
}
