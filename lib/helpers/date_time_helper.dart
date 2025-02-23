import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatHelper {
  static String responseDateToString(String? dateTime) =>
      dateTime?.split('T').first ?? '';

  static String responseTimeToString(String? dateTime) =>
      dateTime?.split('T').last ?? '';

  static String dateNowToString() => DateTime.now().toString().split(' ').first;

  //this will format the data ( Wednesday, Jan 4, 2023 )
  static formatDMY(String? dateTime) {
    DateFormat formatMDY = DateFormat('EEEE, MMM d, yyyy');
    return formatMDY
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  //this will format the data ( 04 Jan, 2023 06:30 AM )
  static formatDMYT(String? dateTime) {
    DateFormat dateFormatTypeMDYT = DateFormat('d MMM, yyyy hh:mm a');
    return dateFormatTypeMDYT
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  //this will format the data ( 04 Jan, 2023)
  static formatDMy(String? dateTime) {
    DateFormat dateFormatTypeMDYT = DateFormat('d MMM, yyyy');
    return dateFormatTypeMDYT
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  //this will format the data ( Jan 04 )
  static formatDM(String? dateTime) {
    DateFormat dateFormatTypeMDYT = DateFormat('MMMd');
    return dateFormatTypeMDYT
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  //-------------------------------------2020-10-25
  static String dateFormatYMD(String? dateTime) {
    DateFormat formatYMD = DateFormat('yyyy-MM-dd');
    return formatYMD
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  //-------------------------------------5:00 PM
  static String dateFormatHM(String? dateTime) {
    DateFormat formatYMD = DateFormat.jm();
    return formatYMD
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  // --------------------------------10:25 to 10:25:00.00Z
  static String timeFormatHMSZ(String? dateTime) {
    var adjustedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      int.tryParse(dateTime?.split(':').first ?? '') ?? 0,
      int.tryParse(dateTime?.split(':').last ?? '') ?? 0,
    );
    var time =
        '${adjustedDateTime.toIso8601String().toString().split('T').last.split('.').first}Z';
    return time;
  }

  // -------------------------------- 10:25:00.00Z to 10:25
  static String timeFormatHM(String? dateTime) {
    var adjustedTime = dateTime?.split(':');
    var time = '${adjustedTime?[0]}:${adjustedTime?[1]}';
    return time;
  }

  // --------------------------------2021-12-21 10:25:00.00Z to 10:25
  static String dateTimeFormatHM(DateTime? dateTime) {
    var a = dateTime?.toString().split(' ');
    var adjustedTime = a?.last.split(':');
    var time = '${adjustedTime?[0]}:${adjustedTime?[1]}';
    return time;
  }

  // --------------------------------2021-12-21T10:25:00.00Z to 10:25
  static String dateTimeTFormatHM(DateTime? dateTime) {
    var a = dateTime?.toString().split('T');
    var adjustedTime = a?.last.split(':');
    var time = '${adjustedTime?[0]}:${adjustedTime?[1]}';
    return time;
  }

  // -------------------------------- Sunday, Monday...
  static String formatDay(String? dateTime) {
    DateFormat formatDay = DateFormat.EEEE();
    return formatDay
        .format(DateTime.parse(dateTime ?? DateTime.now().toString()));
  }

  // ----------------------------------10:25:00.00Z to 2024-12-21 10:25:00.00
  static DateTime textTimeToDateTime(String? textTime) {
    var adjustedTime = textTime?.split(':');
    return DateTime.now().copyWith(
      hour: int.tryParse(adjustedTime?[0] ?? ''),
      minute: int.tryParse(adjustedTime?[1] ?? ''),
    );
  }

  // -------------------------------- String to Time Of Day
  static TimeOfDay stringToTimeOfDay(String s) {
    TimeOfDay startTime = TimeOfDay(
      hour: int.parse(s.split(":")[0]),
      minute: int.parse(s.split(":")[1]),
    );
    return startTime;
  }

  static String removeMS(String? time, {bool appendZ = true}) {
    var adjustedTime = time?.split('.').first;
    if (appendZ) {
      return '${adjustedTime}Z';
    }
    return adjustedTime ?? '';
  }

  static String durationInMinutes(int timeInSeconds) {
    var minutes = (timeInSeconds / 60).floor();
    var seconds = timeInSeconds % 60;
    var minutesInString = minutes.toString().length < 2
        ? minutes.toString().padLeft(2, '0')
        : minutes.toString();
    var secondsInString = seconds.toString().length < 2
        ? seconds.toString().padLeft(2, '0')
        : seconds.toString();
    return '$minutesInString : $secondsInString';
  }
}
