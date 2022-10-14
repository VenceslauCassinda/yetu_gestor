import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import '../../contratos/casos_uso/manipular_entrada_i.dart';
import '../../contratos/casos_uso/manipular_receccao_i.dart';
import '../../contratos/provedores/provedor_receccao_i.dart';
import '../entidades/entrada.dart';
import '../entidades/estado.dart';
import '../entidades/receccao.dart';

class ManipularRececcao implements ManipularRececcaoI {
  final ManipularEntradaI _manipularEntradaI;
  final ProvedorRececcaoI _provedorRececcaoI;
  ManipularRececcao(this._provedorRececcaoI, this._manipularEntradaI) {}

  @override
  Future<void> receberProduto(Produto produto, int quantidade,
      Funcionario funcionario, String motivo) async {
    var data = DateTime.now();
    var receccao = Receccao(
        estado: Estado.ATIVADO,
        idFuncionario: funcionario.id,
        idProduto: produto.id,
        quantidade: quantidade,
        data: data);
    var id = await _provedorRececcaoI.adicionarrRececcao(receccao);

    await _manipularEntradaI.registarEntrada(Entrada(
        produto: produto,
        estado: Estado.ATIVADO,
        idProduto: produto.id,
        idRececcao: id,
        quantidade: quantidade,
        motivo: motivo,
        data: data));
  }

  @override
  Future<void> actualizaRececcao(Receccao receccao) async {
    await _provedorRececcaoI.actualizaRececcao(receccao);
  }

  @override
  Future<void> removerRececcao(Receccao receccao) async {
    await _provedorRececcaoI.removerRececcao(receccao);
  }

  @override
  Future<List<Receccao>> todas() async {
    return await _provedorRececcaoI.todas();
  }

  @override
  Future<List<Receccao>> pegarListaRececcoesFuncionario(
      Funcionario funcionario) async {
    return await _provedorRececcaoI
        .pegarListaRececcoesFuncionario(funcionario.id!);
  }
}
