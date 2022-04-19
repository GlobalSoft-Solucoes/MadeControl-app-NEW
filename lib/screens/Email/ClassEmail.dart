import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// =============== CLASSE DE MENSAGENS ==============

class Email {
  String? _username;
  var smtpServer;

  Email(String? username, String? password) {
    _username = username;
    // ignore: deprecated_member_use
    smtpServer = gmail(_username!, password!);
  }

  //Envia um email para o destinatário, contendo a mensagem com o código
  Future<bool> sendMessage(
      String? mensagem, String? destinatario, String? assunto) async {
    //Configurar a mensagem
    final message = Message()
      ..from = Address(_username!, 'GlobalSoft_ST')
      ..recipients.add(destinatario)
      ..subject = assunto
      ..text = mensagem;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
