import 'package:yetu_gestor/dominio/entidades/entrada.dart';

abstract class ProvedorEntradaI {
  Future<int> registarEntrada(Entrada entrada);
  Future<List<Entrada>> pegarLista();
  Future<List<Entrada>> pegarListaDoProduto(int idProduto);
  Future<List<Entrada>> pegarListaEntradasFuncionario(int idFuncionario);
}
