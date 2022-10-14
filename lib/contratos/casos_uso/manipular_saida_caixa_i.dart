import '../../dominio/entidades/saida_caixa.dart';

abstract class ManipularSaidaCaixaI {
  Future<int> adicionarSaidaCaixa(SaidaCaixa saidaCaixa);
  Future<bool> actualizarSaidaCaixa(SaidaCaixa saidaCaixa);
  Future<int> removerSaidaCaixaDeId(int id);
  Future<List<SaidaCaixa>> pegarLista();
}
