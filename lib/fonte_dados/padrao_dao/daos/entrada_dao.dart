part of '../base_dados.dart';

@DriftAccessor(tables: [
  TabelaEntrada,
  TabelaProduto,
  TabelaRececcao,
  TabelaFuncionario,
  TabelaStock
])
class EntradaDao extends DatabaseAccessor<BancoDados> with _$EntradaDaoMixin {
  EntradaDao(BancoDados attachedDatabase) : super(attachedDatabase);

  Future<List<Entrada>> todas() async {
    List<Entrada> lista = [];
    var res = await (select(tabelaEntrada).join([
      leftOuterJoin(
          tabelaProduto, tabelaEntrada.idProduto.equalsExp(tabelaProduto.id)),
      leftOuterJoin(tabelaRececcao,
          tabelaEntrada.idRececcao.equalsExp(tabelaRececcao.id)),
      leftOuterJoin(
          tabelaStock, tabelaProduto.id.equalsExp(tabelaStock.idProduto)),
    ])
          ..orderBy([OrderingTerm.desc(tabelaEntrada.data)]))
        .get();

    for (var linhaEntradaVsProdutoVsRececcao in res) {
      var produto =
          linhaEntradaVsProdutoVsRececcao.readTableOrNull(tabelaProduto);
      var entrada = linhaEntradaVsProdutoVsRececcao.readTable(tabelaEntrada);
      var receccao = linhaEntradaVsProdutoVsRececcao.readTable(tabelaRececcao);
      var stock = linhaEntradaVsProdutoVsRececcao.readTable(tabelaStock);
      var cadaRececcao = Receccao(
          id: receccao.id,
          estado: receccao.estado,
          idFuncionario: receccao.idFuncionario,
          idProduto: receccao.idProduto,
          quantidade: receccao.quantidade,
          data: receccao.data);

      var resRececcaoVsFuncionario = await select(tabelaRececcao).join([
        leftOuterJoin(tabelaFuncionario,
            tabelaRececcao.idFuncionario.equalsExp(tabelaFuncionario.id)),
      ]).get();

      for (var linhaRececcaoVsFuncionario in resRececcaoVsFuncionario) {
        var funcionario =
            linhaRececcaoVsFuncionario.readTable(tabelaFuncionario);
        cadaRececcao.funcionario =
            SerializadorFuncionario().fromTabela(funcionario);
      }

      lista.add(Entrada(
          receccao: cadaRececcao,
          produto: produto == null
              ? null
              : Produto(
                  id: produto.id,
                  estado: produto.estado,
                  nome: produto.nome,
                  precoCompra: produto.precoCompra,
                  recebivel: produto.recebivel,
                  stock: Stock(
                      id: stock.id,
                      estado: stock.estado,
                      idProduto: stock.idProduto,
                      quantidade: stock.quantidade),
                ),
          estado: entrada.estado,
          motivo: entrada.motivo,
          idProduto: entrada.idProduto,
          idRececcao: entrada.idRececcao,
          quantidade: entrada.quantidade,
          data: entrada.data));
    }

    return lista;
  }

  Future<List<Entrada>> todasComProdutoDeId(int idProduto) async {
    List<Entrada> lista = [];

    var res = await ((select(tabelaEntrada)
              ..where((tbl) => tbl.idProduto.equals(idProduto)))
            .join([
      leftOuterJoin(
          tabelaProduto, tabelaEntrada.idProduto.equalsExp(tabelaProduto.id)),
      leftOuterJoin(tabelaRececcao,
          tabelaEntrada.idRececcao.equalsExp(tabelaRececcao.id)),
      leftOuterJoin(
          tabelaStock, tabelaProduto.id.equalsExp(tabelaStock.idProduto)),
    ])
          ..orderBy([OrderingTerm.desc(tabelaEntrada.data)]))
        .get();

    for (var linhaEntradaVsProdutoVsRececcao in res) {
      var produto =
          linhaEntradaVsProdutoVsRececcao.readTableOrNull(tabelaProduto);
      var entrada = linhaEntradaVsProdutoVsRececcao.readTable(tabelaEntrada);
      var receccao = linhaEntradaVsProdutoVsRececcao.readTable(tabelaRececcao);
      var stock = linhaEntradaVsProdutoVsRececcao.readTable(tabelaStock);

      var cadaRececcao = Receccao(
          id: receccao.id,
          estado: receccao.estado,
          idFuncionario: receccao.idFuncionario,
          idProduto: receccao.idProduto,
          quantidade: receccao.quantidade,
          data: receccao.data);

      var resRececcaoVsFuncionario = await select(tabelaRececcao).join([
        leftOuterJoin(tabelaFuncionario,
            tabelaRececcao.idFuncionario.equalsExp(tabelaFuncionario.id)),
      ]).get();

      for (var linhaRececcaoVsFuncionario in resRececcaoVsFuncionario) {
        var funcionario =
            linhaRececcaoVsFuncionario.readTable(tabelaFuncionario);
        cadaRececcao.funcionario =
            SerializadorFuncionario().fromTabela(funcionario);
      }

      lista.add(Entrada(
          receccao: cadaRececcao,
          produto: produto == null
              ? null
              : Produto(
                  id: produto.id,
                  estado: produto.estado,
                  nome: produto.nome,
                  precoCompra: produto.precoCompra,
                  recebivel: produto.recebivel,
                  stock: Stock(
                      id: stock.id,
                      estado: stock.estado,
                      idProduto: stock.idProduto,
                      quantidade: stock.quantidade),
                ),
          estado: entrada.estado,
          motivo: entrada.motivo,
          idProduto: entrada.idProduto,
          idRececcao: entrada.idRececcao,
          quantidade: entrada.quantidade,
          data: entrada.data));
    }

    return lista;
  }

  Future<int> adicionarEntrada(Entrada entrada) async {
    var res = into(tabelaEntrada).insert(entrada.toCompanion(true));
    return res;
  }

  Future<TabelaEntradaData?> pegarEntradaDeId(int id) async {
    var res = (select(tabelaEntrada)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return res;
  }

  Future<void> actualizar(Entrada entrada) async {
    await update(tabelaEntrada).replace(entrada.toCompanion(true));
  }

  Future<void> removerEntrada(int id) async {
    await (delete(tabelaEntrada)..where((tbl) => tbl.id.equals(id))).go();
  }
}
