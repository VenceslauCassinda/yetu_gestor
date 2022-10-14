part of '../base_dados.dart';

@DriftAccessor(tables: [TabelaRececcao, TabelaProduto, TabelaFuncionario])
class RececcaoDao extends DatabaseAccessor<BancoDados> with _$RececcaoDaoMixin {
  RececcaoDao(BancoDados attachedDatabase) : super(attachedDatabase);

  Future<List<Receccao>> todas() async {
    var res = await (select(tabelaRececcao).join([
      leftOuterJoin(tabelaFuncionario,
          tabelaFuncionario.id.equalsExp(tabelaRececcao.idFuncionario)),
      leftOuterJoin(
          tabelaProduto, tabelaProduto.id.equalsExp(tabelaRececcao.idProduto))
    ])..orderBy([OrderingTerm.desc(tabelaRececcao.data)])).get();
    var lista = res.map((linha) {
      var receccao = linha.readTable(tabelaRececcao);
      var funcionario = linha.readTable(tabelaFuncionario);
      var produto = linha.readTable(tabelaProduto);
      return Receccao(
          estado: receccao.estado,
          funcionario: Funcionario(
            id: funcionario.id,
            estado: funcionario.estado,
            idUsuario: funcionario.idUsuario,
            nomeCompelto: funcionario.nomeCompleto,
          ),
          produto: Produto(
              id: produto.id,
              estado: produto.estado,
              nome: produto.nome,
              precoCompra: produto.precoCompra,
              recebivel: produto.recebivel),
          idFuncionario: receccao.idFuncionario,
          idProduto: receccao.idProduto,
          quantidade: receccao.quantidade,
          data: receccao.data);
    }).toList();
    return lista;
  }
  
  Future<List<Receccao>> todasDoFuncionario(int id) async {
    var res = await ((select(tabelaRececcao)..where((tbl) => tbl.idFuncionario.equals(id))).join([
      leftOuterJoin(tabelaProduto,
          tabelaProduto.id.equalsExp(tabelaRececcao.idProduto))
    ])..orderBy([OrderingTerm.desc(tabelaRececcao.data)])).get();
    var lista = res.map((linha) {
      var receccao = linha.readTable(tabelaRececcao);
      var produto = linha.readTable(tabelaProduto);
      return Receccao(
          estado: receccao.estado,
          produto: Produto(
              id: produto.id,
              estado: produto.estado,
              nome: produto.nome,
              precoCompra: produto.precoCompra,
              recebivel: produto.recebivel),
          idFuncionario: receccao.idFuncionario,
          idProduto: receccao.idProduto,
          quantidade: receccao.quantidade,
          data: receccao.data);
    }).toList();
    return lista;
  }

  Future<int> adicionarRececcao(Receccao receccao) async {
    await into(tabelaRececcao).insert(receccao.toCompanion(true));
    return 1;
  }

  Future<void> actualizaRececcao(Receccao receccao) async {
    await update(tabelaRececcao).replace(receccao.toCompanion(true));
  }

  Future<void> removerRececcao(Receccao receccao) async {
    await (delete(tabelaRececcao)..where((tbl) => tbl.id.equals(receccao.id!)))
        .go();
  }

  Future<TabelaRececcaoData?> pegarRececcaoDeId(int id) async {
    return await (select(tabelaRececcao)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}
