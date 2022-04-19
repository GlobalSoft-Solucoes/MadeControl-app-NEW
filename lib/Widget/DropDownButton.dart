import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class DropDownButton {
  dropDownButton(
    // BuildContext context,
    textTitulo,
    var combobox, {
    double?GetTextTitulo,
    double?marginLeft,
    double?marginTop,
    double?marginBottom,
    double?tituloPaddingBottom,
    double?tituloPaddingTop,
    Color?backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: marginTop != null ? Get.width * marginTop : Get.height * 0.015,
        bottom: marginBottom != null
            ? Get.width * marginBottom
            : Get.height * 0.0,
        left: marginLeft != null ? Get.width * marginLeft : Get.width * 0.015,
        right:
            marginLeft != null ? Get.width * marginLeft : Get.width * 0.015,
      ),
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: Get.height * 0.01),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          children: [
            SizedBox(
              height: tituloPaddingTop != null
                  ? Get.height * tituloPaddingTop
                  : Get.height * 0.005,
            ),
            Text(
              textTitulo ?? ' ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: tituloPaddingBottom != null
                  ? Get.height * tituloPaddingBottom
                  : Get.height * 0.005,
            ),
            Container(
              // width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1)),
              child: combobox,
            ),
          ],
        ),
      ),
    );
  }
}
