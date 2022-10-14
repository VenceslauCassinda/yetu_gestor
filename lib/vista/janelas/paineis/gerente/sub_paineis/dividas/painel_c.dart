import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';

import '../../../../../../contratos/casos_uso/manipular_item_venda_i.dart';
import '../../../../../../contratos/casos_uso/manipular_pagamento_i.dart';
import '../../../../../../contratos/casos_uso/manipular_produto_i.dart';
import '../../../../../../contratos/casos_uso/manipular_stock_i.dart';
import '../../../../../../contratos/casos_uso/manipular_venda_i.dart';
import '../../../../../../dominio/casos_uso/manipula_stock.dart';
import '../../../../../../dominio/casos_uso/manipular_cliente.dart';
import '../../../../../../dominio/casos_uso/manipular_item_venda.dart';
import '../../../../../../dominio/casos_uso/manipular_pagamento.dart';
import '../../../../../../dominio/casos_uso/manipular_preco.dart';
import '../../../../../../dominio/casos_uso/manipular_produto.dart';
import '../../../../../../dominio/casos_uso/manipular_saida.dart';
import '../../../../../../dominio/casos_uso/manipular_venda.dart';
import '../../../../../../dominio/entidades/estado.dart';
import '../../../../../../dominio/entidades/forma_pagamento.dart';
import '../../../../../../dominio/entidades/pagamento.dart';
import '../../../../../../dominio/entidades/pagamento_final.dart';
import '../../../../../../dominio/entidades/venda.dart';
import '../../../../../../fonte_dados/provedores/provedor_cliente.dart';
import '../../../../../../fonte_dados/provedores/provedor_item_venda.dart';
import '../../../../../../fonte_dados/provedores/provedor_pagamento.dart';
import '../../../../../../fonte_dados/provedores/provedor_preco.dart';
import '../../../../../../fonte_dados/provedores/provedor_produto.dart';
import '../../../../../../fonte_dados/provedores/provedor_saida.dart';
import '../../../../../../fonte_dados/provedores/provedor_stock.dart';
import '../../../../../../fonte_dados/provedores/provedor_venda.dart';
import '../../../funcionario/sub_paineis/vendas/layouts/detalhes_venda.dart';
import '../../painel_gerente_c.dart';

class PainelDividasC extends GetxController {
  late ManipularProdutoI _manipularProdutoI;
  late ManipularStockI _manipularStockI;
  late ManipularVendaI _manipularVendaI;
  late ManipularItemVendaI _manipularItemVendaI;
  late PainelGerenteC gerenteC;
  late ManipularPagamentoI _manipularPagamentoI;
  RxList<Venda> lista = RxList();
  List<Venda> listaCopia = [];
  int indiceTabActual = 0;
  var totalDividasPagas = 0.0.obs;
  var totalDividasNaoPagas = 0.0.obs;

  PainelDividasC(this.gerenteC) {
    _manipularStockI = ManipularStock(ProvedorStock());
    _manipularProdutoI = ManipularProduto(
        ProvedorProduto(), _manipularStockI, ManipularPreco(ProvedorPreco()));
    _manipularPagamentoI = ManipularPagamento(ProvedorPagamento());
    _manipularItemVendaI = ManipularItemVenda(
        ProvedorItemVenda(),
        ManipularProduto(ProvedorProduto(), _manipularStockI,
            ManipularPreco(ProvedorPreco())),
        ManipularStock(ProvedorStock()));
    _manipularVendaI = ManipularVenda(
        ProvedorVenda(),
        ManipularSaida(ProvedorSaida(), _manipularStockI),
        ManipularPagamento(ProvedorPagamento()),
        ManipularCliente(ProvedorCliente()),
        _manipularStockI,
        _manipularItemVendaI);
  }
  @override
  void onInit() async {
    await pegarLista();
    await pegarTotalDividas();
    super.onInit();
  }

  void aoPesquisar(String f) {
    lista.clear();
    var res = listaCopia;
    for (var cada in res) {
      var existe = (cada.itensVenda ?? []).firstWhereOrNull((element) =>
          (element.produto?.nome ?? "")
              .toLowerCase()
              .contains(f.toLowerCase()));
      if ((DateTime(cada.data!.year, cada.data!.month, cada.data!.day))
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (DateTime(
                  cada.dataLevantamentoCompra!.year,
                  cada.dataLevantamentoCompra!.month,
                  cada.dataLevantamentoCompra!.day))
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.cliente?.nome ?? "")
              .toLowerCase()
              .toString()
              .contains(f.toLowerCase()) ||
          (cada.cliente?.numero ?? "").toString().contains(f.toLowerCase()) ||
          cada.total.toString().contains(f.toLowerCase()) ||
          cada.parcela.toString().contains(f.toLowerCase()) ||
          existe != null) {
        lista.add(cada);
      }
    }
  }

  Future pegarTotalDividas() async {
    var hoje = DateTime.now();
    var res = await _manipularVendaI.pegarListaTodasPagamentoDividas(hoje);
    for (var cada in res) {
      totalDividasPagas.value += cada.valor ?? 0;
    }
  }

  Future pegarLista() async {
    var res = <Venda>[];
    res = await _manipularVendaI.todasDividas();

    for (var cada in res) {
      lista.add(cada);
      var emFalta = cada.total ?? 0 - (cada.parcela ?? 0);
      totalDividasNaoPagas.value += emFalta;
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  mostraDialogoEntregarEncomenda(Venda venda) {
    mostrarSnack("Sem Permissão");
  }

  Future<void> entregarEncomenda(Venda venda) async {
    mostrarSnack("Sem Permissão");
  }

  void mostrarDialogoDetalhesVenda(Venda venda) {
    mostrarDialogoDeLayou(LayoutDetalhesVenda(
      venda: venda,
    ));
  }

  void mostrarFormasPagamento(Venda venda, BuildContext context,
      {bool? comPagamentoFinal}) async {
    mostrarSnack("Sem Permissão");
  }

  void terminarSessao() {
    gerenteC.terminarSessao();
  }
}
