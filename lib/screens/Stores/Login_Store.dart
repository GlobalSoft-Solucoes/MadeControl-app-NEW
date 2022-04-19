import 'package:mobx/mobx.dart';
part 'Login_Store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  bool? senhamostrar = true;
  @action
  void mostrarSenha() => senhamostrar = senhamostrar!;
}
