
import 'package:flutter_mailer/flutter_mailer.dart';

class UtilAbout {
  void sendHelp() async {
    final MailOptions  email = MailOptions (
      body: '',
      subject: 'Tanya PREMAN',
      recipients: ['adminkrs@akprind.ac.id'],
      isHTML: true,
      bccRecipients: [''],
      ccRecipients: [''],
      attachments: [ '', ],
    );

    await FlutterMailer.send(email);
  }
}
