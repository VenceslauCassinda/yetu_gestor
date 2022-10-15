import 'dart:io';
import 'package:get/get.dart' as getx;
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:get/get.dart' as gett;
import 'package:path_provider/path_provider.dart';
import 'package:yetu_gestor/dominio/entidades/cliente.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/forma_pagamento.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/fonte_dados/padrao_dao/tabelas/tabela_item_venda.dart';
import 'package:yetu_gestor/fonte_dados/padrao_dao/tabelas/tabela_produto.dart';
import 'package:yetu_gestor/fonte_dados/padrao_dao/tabelas/tabela_usuario.dart';
import 'package:yetu_gestor/fonte_dados/padrao_dao/tabelas/tabela_venda.dart';

import '../../dominio/casos_uso/manipular_usuario.dart';
import '../../dominio/entidades/definicoes.dart';
import '../../dominio/entidades/dinheiro_sobra.dart';
import '../../dominio/entidades/entidade.dart';
import '../../dominio/entidades/estado.dart';
import '../../dominio/entidades/item_venda.dart';
import '../../dominio/entidades/nivel_acesso.dart';
import '../../dominio/entidades/pagamento.dart';
import '../../dominio/entidades/pagamento_final.dart';
import '../../dominio/entidades/preco.dart';
import '../../dominio/entidades/produto.dart';
import '../../dominio/entidades/receccao.dart';
import '../../dominio/entidades/saida.dart';
import '../../dominio/entidades/saida_caixa.dart';
import '../../dominio/entidades/stock.dart';
import '../../dominio/entidades/usuario.dart';
import '../../dominio/entidades/venda.dart';
import '../../solucoes_uteis/console.dart';
import '../provedores/provedores_usuario.dart';
import '../serializadores/serializador_funcionario.dart';
import 'tabelas/tabela_cliente.dart';
import 'tabelas/tabela_definicoes.dart';
import 'tabelas/tabela_dinheiro_sobra.dart';
import 'tabelas/tabela_entrada.dart';
import 'tabelas/tabela_forma_pagamento.dart';
import 'tabelas/tabela_funcionario.dart';
import 'tabelas/tabela_pagamento.dart';
import 'tabelas/tabela_pagamento_final.dart';
import 'tabelas/tabela_preco.dart';
import 'tabelas/tabela_receccao.dart';
import 'tabelas/tabela_saida.dart';
import 'tabelas/tabela_saida_caixa.dart';
import 'tabelas/tabela_stock.dart';
import 'tabelas/tabela_entidade.dart';
part 'base_dados.g.dart';
part 'daos/usuario_dao.dart';
part 'daos/stock_dao.dart';
part 'daos/receccao_dao.dart';
part 'daos/entrada_dao.dart';
part 'daos/cliente_dao.dart';
part 'daos/preco_dao.dart';
part 'daos/saida_dao.dart';
part 'daos/produto_dao.dart';
part 'daos/funcionario_dao.dart';
part 'daos/item_venda_dao.dart';
part 'daos/forma_pagamento_dao.dart';
part 'daos/pagamento_dao.dart';
part 'daos/dinheiro_sobra_dao.dart';
part 'daos/venda_dao.dart';
part 'daos/saida_caixa_dao.dart';
part 'daos/entidade_dao.dart';
part 'daos/definicoes_dao.dart';

// DESKTOP DATABASE CONECTION
// LazyDatabase defaultConnection() {
//   return LazyDatabase(() async {
//     final file = File('C://generated_databases/yetu_gestor.db');
//     return NativeDatabase(
//       file,
//     );
//   });
// }

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [
  TabelaUsuario,
  TabelaFuncionario,
  TabelaProduto,
  TabelaPreco,
  TabelaVenda,
  TabelaItemVenda,
  TabelaEntrada,
  TabelaSaida,
  TabelaStock,
  TabelaRececcao,
  TabelaCliente,
  TabelaItemVenda,
  TabelaFormaPagamento,
  TabelaPagamento,
  TabelaDinheiroSobra,
  TabelaPagamentoFinal,
  TabelaSaidaCaixa,
  TabelaEntidade,
  TabelaDefinicoes,
])
class BancoDados extends _$BancoDados {
  BancoDados() : super(_openConnection());
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
      var usuario = Usuario.registo("admin", "11111111");
      usuario.nivelAcesso = NivelAcesso.ADMINISTRADOR;
      await ManipularUsuario(ProvedorUsuario()).registarUsuario(usuario);
      await DefinicoesDao(this).adicionarDefinicoes(Definicoes(
          estado: Estado.ATIVADO,
          tipoEntidade: TipoEntidade.COMERCIAL,
          tipoNegocio: TipoNegocio.RETALHO));
    }, onUpgrade: (m, from, to) async {
      if (from < 4) {
        await m.addColumn(tabelaRececcao, tabelaRececcao.dataPagamento);
        await m.addColumn(tabelaRececcao, tabelaRececcao.idPagante);
      }
    });
  }
}
