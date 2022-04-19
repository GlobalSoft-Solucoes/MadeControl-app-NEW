// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Login_Store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$senhamostrarAtom = Atom(name: '_LoginStoreBase.senhamostrar');

  @override
  bool? get senhamostrar {
    _$senhamostrarAtom.reportRead();
    return super.senhamostrar;
  }

  @override
  set senhamostrar(bool? value) {
    _$senhamostrarAtom.reportWrite(value, super.senhamostrar, () {
      super.senhamostrar = value;
    });
  }

  final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase');

  @override
  void mostrarSenha() {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.mostrarSenha');
    try {
      return super.mostrarSenha();
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
senhamostrar: $senhamostrar
    ''';
  }
}
