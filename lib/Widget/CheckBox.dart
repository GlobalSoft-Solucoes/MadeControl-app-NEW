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
    double? sizeTextTitulo,
    double? marginLeft,
    double? marginTop,
    double? marginBottom,
    double? tituloMarginLeft,
    double? distanciaTituloDosChecks,
    double? distanciaEntreChecks,
    Color? backgroundColor,
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

  checkBoxTresOpcoes(
    BuildContext context,
    textTitulo,
    textCheck01,
    textChack02,
    textChack03,
    valueCheck01,
    valueCheck02,
    valueCheck03,
    onClickCheck01(),
    onClickCkeck02(),
    onClickCkeck03(), {
    double? sizeTextTitulo,
    double? marginLeft,
    double? marginTop,
    double? marginBottom,
    double? tituloMarginLeft,
    double? distanciaTituloDosChecks,
    double? distanciaEntreChecks,
    double? distanciaUltimocheck,
    Color? backgroundColor,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      padding: EdgeInsets.only(
        top: marginTop != null ? size.width * marginTop : size.height * 0.03,
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
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textCheck01 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check1'),
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
                      textChack02 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check2'),
                    value: valueCheck02,
                    onChanged: (selectCheck01) {
                      onClickCkeck02();
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
                      textChack03 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check3'),
                    value: valueCheck03,
                    onChanged: (selectCheck01) {
                      onClickCkeck03();
                    },
                  ),
                ),
                SizedBox(
                    width: distanciaUltimocheck != null
                        ? size.width * distanciaUltimocheck
                        : size.width * 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  checkBoxQuebraTresOpcoes(
    BuildContext context,
    textTitulo,
    textCheck01,
    textChack02,
    textChack03,
    valueCheck01,
    valueCheck02,
    valueCheck03,
    onClickCheck01(),
    onClickCkeck02(),
    onClickCkeck03(), {
    double? sizeTextTitulo,
    double? marginLeft,
    double? marginTop,
    double? marginBottom,
    double? tituloMarginLeft,
    double? distanciaTituloDosChecks,
    double? distanciaEntreChecks,
    double? distanciaUltimocheck,
    Color? backgroundColor,
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
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textCheck01 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check1'),
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
                      textChack02 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check2'),
                    value: valueCheck02,
                    onChanged: (selectCheck01) {
                      onClickCkeck02();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textChack03 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check3'),
                    value: valueCheck03,
                    onChanged: (selectCheck01) {
                      onClickCkeck03();
                    },
                  ),
                ),
                SizedBox(
                    width: distanciaUltimocheck != null
                        ? size.width * distanciaUltimocheck
                        : size.width * 0),
              ],
            ),
            SizedBox(
              height: distanciaTituloDosChecks != null
                  ? size.height * distanciaTituloDosChecks
                  : size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  checkBoxQuebraCincoOpcoes(
    BuildContext context,
    textTitulo,
    textCheck01,
    textChack02,
    textChack03,
    textChack04,
    textChack05,
    valueCheck01,
    valueCheck02,
    valueCheck03,
    valueCheck04,
    valueCheck05,
    onClickCheck01(),
    onClickCkeck02(),
    onClickCkeck03(),
    onClickCheck04(),
    onClickCheck05(), {
    double? sizeTextTitulo,
    double? marginLeft,
    double? marginTop,
    double? marginBottom,
    double? tituloMarginLeft,
    double? distanciaTituloDosChecks,
    double? distanciaEntreChecks,
    double? distanciaUltimocheck,
    Color? backgroundColor,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      padding: EdgeInsets.only(
        top: marginTop != null ? size.width * marginTop : size.height * 0.03,
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
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textCheck01 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check1'),
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
                      textChack02 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check2'),
                    value: valueCheck02,
                    onChanged: (selectCheck01) {
                      onClickCkeck02();
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
                      textChack03 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check3'),
                    value: valueCheck03,
                    onChanged: (selectCheck01) {
                      onClickCkeck03();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textChack04 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check4'),
                    value: valueCheck04,
                    onChanged: (selectCheck01) {
                      onClickCheck04();
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
                      textChack05 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check5'),
                    value: valueCheck05,
                    onChanged: (selectCheck01) {
                      onClickCheck05();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: distanciaTituloDosChecks != null
                  ? size.height * distanciaTituloDosChecks
                  : size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  checkBoxQuebraQuatroOpcoes(
    BuildContext context,
    textTitulo,
    textCheck01,
    textChack02,
    textChack03,
    textChack04,
    valueCheck01,
    valueCheck02,
    valueCheck03,
    valueCheck04,
    onClickCheck01(),
    onClickCkeck02(),
    onClickCkeck03(),
    onClickCheck04(), {
    double? sizeTextTitulo,
    double? marginLeft,
    double? marginTop,
    double? marginBottom,
    double? tituloMarginLeft,
    double? distanciaTituloDosChecks,
    double? distanciaEntreChecks,
    double? distanciaUltimocheck,
    Color? backgroundColor,
  }) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size size = mediaQuery.size;
    return Container(
      padding: EdgeInsets.only(
        top: marginTop != null ? size.width * marginTop : size.height * 0.03,
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
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textCheck01 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check1'),
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
                      textChack02 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check2'),
                    value: valueCheck02,
                    onChanged: (selectCheck01) {
                      onClickCkeck02();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(
                      textChack04 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check4'),
                    value: valueCheck04,
                    onChanged: (selectCheck01) {
                      onClickCheck04();
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
                      textChack03 ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    key: Key('check3'),
                    value: valueCheck03,
                    onChanged: (selectCheck01) {
                      onClickCkeck03();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: distanciaTituloDosChecks != null
                  ? size.height * distanciaTituloDosChecks
                  : size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  // ButtonSelect(
  //   BuildContext context,
  //   textTitulo,
  //   textCheck01,
  //   textChack02,
  //   valueCheck01,
  //   valueCheck02,
  //   onClickCheck01(),
  //   onClickCkeck02(), {
  //   double? sizeTextTitulo,
  //   double? marginLeft,
  //   double? marginTop,
  //   double? marginBottom,
  //   double? tituloMarginLeft,
  //   double? distanciaTituloDosChecks,
  //   double? distanciaEntreChecks,
  //   Color? backgroundColor,
  // }) {
  //   MediaQueryData mediaQuery = MediaQuery.of(context);
  //   Size size = mediaQuery.size;
  //   return GestureDetector(
  //     onTap: () async {
  //       setState(() {
  //         opcButtonMedida = '1';
  //         opcProcessproduto.numproduto == 1
  //             ? valorButtonMedida = '2,8'
  //             : opcProcessproduto.numproduto == 2
  //                 ? valorButtonMedida = '3'
  //                 : opcProcessproduto.numproduto == 3
  //                     ? valorButtonMedida = '3'
  //                     : valorButtonMedida = '';
  //       });
  //     },
  //     child: Container(
  //       width: size.width * 0.4,
  //       height: size.height * 0.08,
  //       alignment: Alignment.center,
  //       child: Text(
  //         opcProcessproduto.numproduto == 1
  //             ? '2,8'
  //             : opcProcessproduto.numproduto == 2
  //                 ? '3'
  //                 : opcProcessproduto.numproduto == 3
  //                     ? '3'
  //                     : '',
  //         style: TextStyle(
  //             color: opcButtonMedida == '1' ? corTextoEscolhido : corTexto,
  //             fontSize: 21,
  //             fontWeight: FontWeight.w700),
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15),
  //         color: opcButtonMedida == '1' ? mudarCor : corMedida,
  //         border: Border.all(
  //           color: Colors.red[100]!,
  //           width: 3,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
