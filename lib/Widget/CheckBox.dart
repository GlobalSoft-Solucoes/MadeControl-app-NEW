import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckBox extends State {
  checkBoxDuasOpcoes(
    BuildContext context,
    textTitulo,
    textCheck01,
    textChack02,
    valueCheck01,
    valueCheck02,
    onClickCheck01(),
    onClickCkeck02(), {
    double?sizeTextTitulo,
    double?marginLeft,
    double?marginTop,
    double?marginBottom,
    double?tituloMarginLeft,
    double?distanciaTituloDosChecks,
    double?distanciaEntreChecks,
    Color?backgroundColor,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      padding: EdgeInsets.only(
        top: marginTop != null ? size.width * marginTop : size.height * 0.0,
        bottom: marginBottom != null
            ? size.width * marginBottom
            : size.height * 0.0,
        left: marginLeft != null ? size.width * marginLeft : size.width * 0.02,
        right: marginLeft != null ? size.width * marginLeft : size.width * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            Text(
              textTitulo ?? ' ',
              style: TextStyle(
                fontSize: sizeTextTitulo ?? 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: distanciaTituloDosChecks != null
                  ? size.height * distanciaTituloDosChecks
                  : size.height * 0.01,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        textCheck01 ?? 'Venda normal',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      key: Key('check5'),
                      value: valueCheck01,
                      onChanged: (selectCheck01) {
                        onClickCheck01();
                      },
                    ),
                  ),
                  SizedBox(
                      width: distanciaEntreChecks != null
                          ? size.width * distanciaEntreChecks
                          : size.width * 0),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(
                        textChack02 ?? 'Venda de balcão',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      key: Key('check6'),
                      value: valueCheck02,
                      onChanged: (selectCheck01) {
                        onClickCkeck02();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
