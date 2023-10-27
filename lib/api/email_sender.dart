import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pos/database/store_db.dart';
import 'package:pos/utils/alert_message.dart';
import 'dart:developer' as dev;

import '../models/store.dart';

class EmailSender {
  static sendEmail(String recipients, BuildContext context,
      {String? title, String? body, List<FileAttachment>? attachment}) async {
    Store store = StoreDB().getStore();
    // Note that using a username and password for gmail only works if
    // you have two-factor authentication enabled and created an App password.
    // Search for "gmail app password 2fa"
    // The alternative is to use oauth.
    String username = store.email2.toLowerCase();
    String password = store.password;
    String smtp = store.smtpServer.toLowerCase();

    var smtpServer;

    if (isGmail(username)) {
      smtpServer = gmail(username, password);
    }
    // Use the SmtpServer class to configure an SMTP server:
    else {
      smtpServer = SmtpServer(smtp,
          port: 465, password: password, ssl: true, username: username);
    }
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, store.companyName)
      ..recipients.add(recipients)
      ..subject = title ?? ''
      ..text = body ?? ''
      ..attachments = attachment ?? [];

    try {
      await send(message, smtpServer);
      if (context.mounted) AlertMessage.snakMessage('Message sent', context);
    } on MailerException catch (e) {
      if (context.mounted) {
        AlertMessage.snakMessage('Message not sent', context);
      }

      print(e.toString());

      for (var p in e.problems) {
        dev.log('Problem: ${p.code}: ${p.msg}');
      }
    }
    // DONE

    // Let's send another message using a slightly different syntax:

    // Addresses without a name part can be set directly.
    // For instance `..recipients.add('destination@example.com')`
    // If you want to display a name part you have to create an
    // Address object: `new Address('destination@example.com', 'Display name part')`
    // Creating and adding an Address object without a name part
    // `new Address('destination@example.com')` is equivalent to
    // adding the mail address as `String`.
    // final equivalentMessage = Message()
    //   ..from = Address(username, 'Your name 😀')
    //   ..recipients.add(Address('destination@example.com'))
    //   ..ccRecipients
    //       .addAll([Address('destCc1@example.com'), 'destCc2@example.com'])
    //   ..bccRecipients.add('bccAddress@example.com')
    //   ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
    //   ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    //   ..html =
    //       '<h1>Test</h1>\n<p>Hey! Here is some HTML content</p><img src="cid:myimg@3.141"/>'
    //   ..attachments = [
    //     FileAttachment(File('exploits_of_a_mom.png'))
    //       ..location = Location.inline
    //       ..cid = '<myimg@3.141>'
    //   ];

    // final sendReport2 = await send(equivalentMessage, smtpServer);

    // // Sending multiple messages with the same connection
    // //
    // // Create a smtp client that will persist the connection
    // var connection = PersistentConnection(smtpServer);

    // // Send the first message
    // await connection.send(message);

    // // send the equivalent message
    // await connection.send(equivalentMessage);

    // // close the connection
    // await connection.close();
  }

  static bool isGmail(String username) {
    return username.endsWith('@gmail.com');
  }
}
