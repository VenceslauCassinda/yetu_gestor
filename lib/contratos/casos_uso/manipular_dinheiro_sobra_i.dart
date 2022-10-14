import 'package:yetu_gestor/dominio/entidades/dinheiro_sobra.dart';

abstract class ManipularDinheiroSobraI {
  Future<int> adicionarDinheiroSobra(DinheiroSobra dinheiroSobra);
  Future<bool> actualizarDinheiroSobra(DinheiroSobra dinheiroSobra);
  Future<int> removerDinheiroSobraDeId(int id);
  Future<List<DinheiroSobra>> pegarLista();
}
