class DataAtual {
  converterData(var currentDate) {
    DateTime currentDate = DateTime.now();
    var dia;
    var mes;
    var ano;
    var dataBr;
    String? dataConversao = currentDate.toString();

    ano = dataConversao.substring(0, 4);
    mes = dataConversao.substring(5, 7);
    dia = dataConversao.substring(8, 10);
    dataBr = dia + '/' + mes + '/' + ano;

    print(dataBr);
    return dataBr;
  }

  pegardataBR() {
    var dia;
    var mes;
    var ano;
    var dataAtual;

    dia = DateTime.now().day;
    mes = DateTime.now().month;
    ano = DateTime.now().year;

    if (mes < 10) {
      mes = '0' + mes.toString();
    }
    if (dia < 10) {
      dia = '0' + dia.toString();
    }
    return dataAtual = '$dia/$mes/$ano';
  }

  pegardataEUA() {
    var dia;
    var mes;
    var ano;
    var dataAtual;

    dia = DateTime.now().day;
    mes = DateTime.now().month;
    ano = DateTime.now().year;

    if (mes < 10) {
      mes = '0' + mes.toString();
    }
    if (dia < 10) {
      dia = '0' + dia.toString();
    }

    return dataAtual = '$ano-$mes-$dia';
  }

  pegarHora() {
    var hora;
    var minutos;
    var horaAtual;

    hora = DateTime.now().hour;
    minutos = DateTime.now().minute;

    if (hora < 10) {
      hora = '0' + hora.toString();
    }
    if (minutos < 10) {
      minutos = '0' + minutos.toString();
    }

    return horaAtual = '$hora:$minutos';
  }

  pegarHoraMinutoSegundo() {
    var hora;
    var minutos;
    var horaAtual;
    var segundo;

    hora = DateTime.now().hour;
    minutos = DateTime.now().minute;
    segundo = DateTime.now().second;

    if (hora < 10) {
      hora = '0' + hora.toString();
    }
    if (minutos < 10) {
      minutos = '0' + minutos.toString();
    }
    if (segundo < 10) {
      segundo = '0' + segundo.toString();
    }

    return horaAtual = '$hora:$minutos:$segundo';
  }

  validarDataSelecionada(fieldController) {
    var dia;
    var mes;
    var ano;
    var data;

    // Data da entrega
    dia = fieldController.text.substring(0, 2);
    mes = fieldController.text.substring(3, 5);
    ano = fieldController.text.substring(6, 10);
    data = ano + '-' + mes + '-' + dia;

    if (fieldController.text.trim().isEmpty) {
      return false;
      // MsgPopup().msgFeedback(
      //     context, '\nA data não pode ficar vazia', 'Data inválida');
    } else if (fieldController.text.length < 10) {
      return false;
      // MsgPopup()
      //     .msgFeedback(context, '\nConfira a data informada', 'Data inválida');
    } else if (dia.length < 2 || mes.length < 2 || ano.length < 4) {
      return false;
      // MsgPopup()
      //     .msgFeedback(context, '\nConfira a data informada', 'Data inválida');
    } else if (int.tryParse(dia)! > 31 ||
        int.tryParse(mes)! > 12 ||
        int.tryParse(ano)! < ano.year) {
      return false;
      // MsgPopup()
      //     .msgFeedback(context'\nConfira a data informada', 'Data inválida');
    }

    return data = '$ano-$mes-$dia';
  }
}
