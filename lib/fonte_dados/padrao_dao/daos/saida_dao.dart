part of '../base_dados.dart';

@DriftAccessor(tables: [TabelaSaida, TabelaProduto])
class SaidaDao extends DatabaseAccessor<BancoDados> with _$SaidaDaoMixin {
  SaidaDao(BancoDados attachedDatabase) : super(attachedDatabase);

  Future<List<Saida>> todas() async {
    var res = await (select(tabelaSaida).join([
      leftOuterJoin(
          tabelaProduto, tabelaSaida.idProduto.equalsExp(tabelaProduto.id))
    ])..orderBy([OrderingTerm.desc(tabelaSaida.data)])).get();
    var lista = res.map((linha) {
      var produto = linha.readTable(tabelaProduto);
      var saida = linha.readTable(tabelaSaida);
      return Saida(
          produto: Produto(
            id: produto.id,
            estado: produto.estado,
            nome: produto.nome,
            precoCompra: produto.precoCompra,
            recebivel: produto.recebivel,
          ),
          estado: saida.estado,
          motivo: saida.motivo,
          idProduto: saida.idProduto,
          idVenda: saida.idVenda,
          quantidade: saida.quantidade,
          data: saida.data);
    }).toList();
    return lista;
  }

  Future<List<Saida>> todasComProdutoDeId(int idProduto) async {
    var res = await ((select(tabelaSaida)
          ..where((tbl) => tbl.idProduto.equals(idProduto)))
        .join([
      leftOuterJoin(
          tabelaProduto, tabelaSaida.idProduto.equalsExp(tabelaProduto.id))
    ])..orderBy([OrderingTerm.desc(tabelaSaida.data)])).get();
    var lista = res.map((linha) {
      var produto = linha.readTable(tabelaProduto);
      var saida = linha.readTable(tabelaSaida);
      return Saida(
          produto: Produto(
            id: produto.id,
            estado: produto.estado,
            nome: produto.nome,
            precoCompra: produto.precoCompra,
            recebivel: produto.recebivel,
          ),
          estado: saida.estado,
          motivo: saida.motivo,
          idProduto: saida.idProduto,
          idVenda: saida.idVenda,
          quantidade: saida.quantidade,
          data: saida.data);
    }).toList();
    return lista;
  }

  Future<int> adicionarSaida(Saida saida) async {
    var res = into(tabelaSaida).insert(TabelaSaidaCompanion.insert(
        estado: Estado.ATIVADO,
        idProduto: saida.idProduto!,
        idVenda: Value(saida.idVenda),
        motivo: Value(saida.motivo),
        quantidade: saida.quantidade!,
        data: saida.data!));
    return res;
  }

  Future<TabelaSaidaData?> pegarSaidaDeId(int id) async {
    var res = (select(tabelaSaida)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return res;
  }

  Future<void> actualizar(Saida saida) async {
    await update(tabelaSaida).replace(TabelaSaidaCompanion.insert(
        estado: saida.estado!,
        idProduto: saida.idProduto!,
        idVenda: Value(saida.idVenda),
        motivo: Value(saida.motivo),
        quantidade: saida.quantidade!,
        data: saida.data!));
  }

  Future<void> removerSaida(int id) async {
    await (delete(tabelaSaida)..where((tbl) => tbl.id.equals(id))).go();
  }
}
