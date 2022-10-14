import 'package:yetu_gestor/dominio/entidades/receccao.dart';

abstract class ProvedorRececcaoI {
  Future<void> receberProduto(Receccao receccao);
  Future<List<Receccao>> todas();
  Future<Receccao?> pegarRececcaoDeId(int id);
  Future<List<Receccao>> pegarListaRececcoesFuncionario(int id);
  Future<void> actualizaRececcao(Receccao receccao);
  Future<int> adicionarrRececcao(Receccao receccao);
  Future<void> removerRececcao(Receccao receccao);
}
