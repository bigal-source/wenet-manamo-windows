import 'package:intl/intl.dart';

class DateUtil {

  static  jDate({String? dateStr})  {
    if(dateStr == null){
      return '';
    }
    final DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
    final String result = DateFormat.yMMMMd('ja').format(date);
    return result;
  }

  static  convertSqlDate(DateTime dateTime)  {
    var date = dateTime;
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final String result = format.format(date);
    return result;
  }

  static  sqlDate({required String date})  {
    var date0 = DateTime.parse(date).toLocal();
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final String result = format.format(date0);
    return result;
  }

  static  displayDate(String date)  {
    var date0 = DateTime.parse(date).toLocal();
    final DateFormat format = DateFormat('dd/MM/yyyy');
    final String result = format.format(date0);
    return result;
  }

  static String  plusSqlDate( DateTime date, int num)  {

    var date0   = date;
    var newDate = date0.add(Duration(days: num));
    final DateFormat format = DateFormat('yyyy-MM-dd');
    final String result = format.format(newDate);
    return result;
  }

  static String  plusDisplayDate({required String date, required int num})  {

    var date0   = DateTime.parse(date);
    var newDate = date0.add(Duration(days: num));
    final DateFormat format = DateFormat('dd/MM/yyyy');
    final String result = format.format(newDate);
    return result;
  }

  static int  daysBetween({required String dateMax, required String dateMin})  {

    DateTime dateMax0 = DateTime.parse(dateMax);
    DateTime dateMin0 = DateTime.parse(dateMin);
    return (dateMax0.difference(dateMin0).inHours / 24).round();

  }


}