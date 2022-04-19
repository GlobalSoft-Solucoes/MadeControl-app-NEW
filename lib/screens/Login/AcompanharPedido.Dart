// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:madecontrol_desenvolvimento/Statics/Static_GrupoPedido.dart';
// import 'package:madecontrol_desenvolvimento/Widget/Cabecalho.dart';
// import 'package:get/get.dart';
// import 'package:madecontrol_desenvolvimento/Widget/ListFieldsDataBase.dart';
// import 'package:madecontrol_desenvolvimento/Widget/TextField.dart';
// import 'package:madecontrol_desenvolvimento/models/Models_GrupoPedido.dart';
// import 'package:madecontrol_desenvolvimento/models/Models_Usuario.dart';
// import 'package:madecontrol_desenvolvimento/models/constantes.dart';
// import 'package:http/http.dart' as http;
// import 'package:madecontrol_desenvolvimento/Statics/Static_Cliente.dart';
// import 'package:madecontrol_desenvolvimento/screens/Pedido/PedidosEmProducaoDoCliente.dart';

// class AcompanharPedido extends StatefulWidget {
//   @override
//   _AcompanharPedidoState createState() => _AcompanharPedidoState();
// }

// class _AcompanharPedidoState extends State<AcompanharPedido> {
//   final 
//   TextEditingController controllerCodCliente = TextEditingController();
//   var dadosListagem = <ModelsGrupoPedido>[];
//   RxBool? loading = true.obs;
//   Future<dynamic> listarDados() async {
//     final response = await http.get(
//       Uri.parse(
//           ListarGruposPedidosProducao + ModelsUsuarios.caminhoBaseUser.toString()),
//       // Uri.parse(ListaGruposPedidosPorCodigoCliente +
//       //     '/' +
//       //     '1111' +
//       //     // ''controllerCodCliente.toString()'' +
//       //     '/' +
//       //     ModelsUsuarios.caminhoBaseUser.toString()),
//       headers: {"authorization": ModelsUsuarios.tokenAuth.toString()},
//     );
//     if (response.statusCode == 401) {
//       Navigator.pushNamed(context, '/login');
//     }
//     //IF(MOUNTED) É nescessario para não recarregar a arvore apos retornar das outras listas
//     if (mounted) {
//       setState(
//         () {
//           Iterable lista = json.decode(response.body);
//           dadosListagem =
//               lista.map((model) => ModelsGrupoPedido.fromJson(model)).toList();
//         },
//       );
//     }
//     loading!.value = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     Size size = mediaQuery.size;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             color: Colors.green[200],
//             height: size.height,
//             width: size.width,
//             child: Column(
//               children: [
//                 Cabecalho().tituloCabecalho(
//                   context,
//                   // 'Lista de pedidos em produção',
//                   '',
//                   sizeIcone: 37,
//                   iconeVoltar: true,
//                   sizeTextTitulo: 0.055,
//                   marginBottom: 0,
//                   marginTop: 0.02,
//                 ),
//                 CampoText().textField(
//                   controllerCodCliente,
//                   "Código de cliente:",
//                   raioBorda: 15,
//                   confPadding: EdgeInsets.only(
//                     top: size.width * 0.04,
//                     bottom: size.width * 0.07,
//                     left: size.width * 0.02,
//                     right: size.width * 0.02,
//                   ),
//                   icone: Icons.code,
//                   fontWeigth: FontWeight.w700,
//                   campoSenha: true,
//                   fontLabel: 22,
//                   backgroundColor: Colors.white.withOpacity(0.7),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: size.width * 0.02,
//                     right: size.width * 0.02,
//                     bottom: size.height * 0.01,
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       top: 5,
//                       bottom: 5,
//                     ),
//                     width: size.width,
//                     height: size.height * 0.70,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.white,
//                     ),
//                     child: FutureBuilder(
//                       future: listarDados(),
//                       builder: (BuildContext context, snapshot) {
//                         return Obx(
//                           () => loading!.value == true
//                               ? Center(
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : ListView.builder(
//                                   itemCount: dadosListagem.length,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: EdgeInsets.only(
//                                         left: size.width * 0.015,
//                                         right: size.width * 0.015,
//                                         top: size.width * 0.01,
//                                         bottom: size.width * 0.01,
//                                       ),
//                                       child: Container(
//                                         child: Slidable(
//                                           fastThreshold: 12,
//                                           actionPane:
//                                               SlidableDrawerActionPane(),
//                                           closeOnScroll: false,
//                                           actionExtentRatio: 0.25,
//                                           controller: slidableController,
//                                           secondaryActions: <Widget>[],
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               FieldsGrupoPedido()
//                                                   .buscaDadosGrupoPedidoPorId(
//                                                       dadosListagem[index]
//                                                           .idGrupoPedido);
//                                               Cliente.nomeCliente =
//                                                   dadosListagem[index]
//                                                       .nomeCliente;
//                                               Cliente.idGrupoPedido =
//                                                   dadosListagem[index]
//                                                       .idGrupoPedido;
//                                               Cliente.codigoGrupo =
//                                                   dadosListagem[index]
//                                                       .codigoGrupo;
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       PedidosProducaoCliente(
//                                                     idGrupoPedido:
//                                                         dadosListagem[index]
//                                                             .idGrupoPedido,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             child: Container(
//                                               height: size.height * 0.17,
//                                               width: size.width,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                   5,
//                                                 ),
//                                                 color: Colors.grey[400],
//                                               ),
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 padding: EdgeInsets.only(
//                                                   top: 3,
//                                                   left: 0,
//                                                   right: 0,
//                                                 ),
//                                                 child: SingleChildScrollView(
//                                                   child: Container(
//                                                     child: ListTile(
//                                                       title: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           FieldsDatabase()
//                                                               .listaDadosBanco(
//                                                             'Código do grupo: ',
//                                                             dadosListagem[index]
//                                                                 .codigoGrupo,
//                                                             sizeCampoBanco: 20,
//                                                             sizeTextoCampo: 20,
//                                                           ),
//                                                           SizedBox(height: 3),
//                                                           FieldsDatabase()
//                                                               .listaDadosBanco(
//                                                             'Cliente: ',
//                                                             dadosListagem[index]
//                                                                 .nomeCliente,
//                                                             sizeCampoBanco: 20,
//                                                             sizeTextoCampo: 20,
//                                                           ),
//                                                           SizedBox(height: 3),
//                                                           FieldsDatabase()
//                                                               .listaDadosBanco(
//                                                             'Cadastro: ',
//                                                             dadosListagem[index]
//                                                                 .dataCadastro,
//                                                             sizeCampoBanco: 20,
//                                                             sizeTextoCampo: 20,
//                                                           ),
//                                                           if (dadosListagem[
//                                                                       index]
//                                                                   .dataEntrega !=
//                                                               null)
//                                                             SizedBox(height: 3),
//                                                           if (dadosListagem[
//                                                                       index]
//                                                                   .dataEntrega !=
//                                                               null)
//                                                             FieldsDatabase()
//                                                                 .listaDadosBanco(
//                                                               'Entrega: ',
//                                                               dadosListagem[
//                                                                       index]
//                                                                   .dataEntrega,
//                                                               sizeCampoBanco:
//                                                                   20,
//                                                               sizeTextoCampo:
//                                                                   20,
//                                                             ),
//                                                           SizedBox(height: 3),
//                                                           FieldsDatabase()
//                                                               .listaDadosBanco(
//                                                             'Status: ',
//                                                             dadosListagem[index]
//                                                                 .status,
//                                                             sizeCampoBanco: 20,
//                                                             sizeTextoCampo: 20,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
