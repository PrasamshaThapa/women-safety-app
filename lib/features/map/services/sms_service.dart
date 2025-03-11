import 'package:url_launcher/url_launcher.dart';

class SMSService {
  Future<void> sendSMS(String phoneNumber, String message) async {
    final Uri uri = Uri.parse(
      'sms:$phoneNumber?body=${Uri.encodeComponent(message)}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch SMS';
      }
    } catch (e) {
      throw Exception('Failed to send SMS: $e');
    }
    // try {
    //   await sendSMS(message: message, recipients: [phoneNumber]);
    // } catch (e) {
    //   throw Exception('Failed to send SMS: $e');
    // }
  }
}
