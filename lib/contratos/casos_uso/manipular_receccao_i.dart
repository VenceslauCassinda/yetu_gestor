import 'package:yetu_gestor/dominio/entidades/receccao.dart';

import '../../dominio/entidades/funcionario.dart';
import '../../dominio/entidades/produto.dart';

abstract class ManipularRececcaoI {
  Future<void> receberProduto(
      Produto produto, int quantidade, Funcionario funcionario, String motivo);
  Future<List<Receccao>> pegarListaRececcoesFuncionario(Funcionario funcionario);
  Future<List<Receccao>> todas();
  Future<void> actualizaRececcao(Receccao receccao);
  Future<void> removerRececcao(Receccao receccao);
}
