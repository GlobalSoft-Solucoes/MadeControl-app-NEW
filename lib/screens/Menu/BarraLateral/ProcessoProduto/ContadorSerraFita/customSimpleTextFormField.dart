// // ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

// import 'package:flutter/material.dart';

// class SimpleTextFormField extends StatelessWidget {
//   final double? sizeTextTitulo;
//   final Function? onChanged;

//   // ignore: use_key_in_widget_constructors
//   const SimpleTextFormField({
//     required this.onChanged,
//     this.sizeTextTitulo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       padding: EdgeInsets.only(
//         left: 5,
//         right: 5,
//         top: Get.height * 0.02,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             width: 2,
//             color: Colors.black,
//             style: BorderStyle.solid,
//           ),
//         ),
//         child: Column(
//           children: [
//             const Text(
//               'Medida',
//               style: TextStyle(
//                 fontSize: 21,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: Get.height * 0.01,
//             ),
//             Container(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text(
//                             '40',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w700, fontSize: 20),
//                           ),
//                           key: Key('check1'),
//                           value: prancha40,
//                           onChanged: (bool? valor) {
//                             setState(
//                               () {
//                                 prancha30 = false;
//                                 prancha35 = false;
//                                 prancha40 = true;
//                                 tipoPrancha = '40';
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: CheckboxListTile(
//                           title: const Text(
//                             '35',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w700, fontSize: 20),
//                           ),
//                           key: Key('check1'),
//                           value: prancha35,
//                           onChanged: (bool? valor) {
//                             setState(
//                               () {
//                                 prancha30 = false;
//                                 prancha35 = true;
//                                 prancha40 = false;
//                                 tipoPrancha = '35';
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(width: size.width * 0.02),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CheckboxListTile(
//                             title: const Text(
//                               '30',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w700, fontSize: 20),
//                             ),
//                             key: Key('check3'),
//                             value: prancha30,
//                             onChanged: (bool? valor) {
//                               setState(() {
//                                 prancha30 = true;
//                                 prancha35 = false;
//                                 prancha40 = false;
//                                 tipoPrancha = '30';
//                               });
//                             }),
//                       ),
//                       SizedBox(width: size.width * 0.5),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//   }
// }
