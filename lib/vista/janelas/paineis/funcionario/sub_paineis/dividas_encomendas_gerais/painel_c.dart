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
import '../../../../../../recursos/constantes.dart';
import '../../../../../../solucoes_uteis/formato_dado.dart';
import '../../../../../../solucoes_uteis/geradores.dart';
import '../../../gerente/layouts/layout_forma_pagamento.dart';
import '../../painel_funcionario_c.dart';
import '../vendas/layouts/detalhes_venda.dart';

class PainelDividasEncomendasC extends GetxController {
  late ManipularProdutoI _manipularProdutoI;
  late ManipularStockI _manipularStockI;
  late ManipularVendaI _manipularVendaI;
  late ManipularItemVendaI _manipularItemVendaI;
  late PainelFuncionarioC painelFuncionarioC;
  late ManipularPagamentoI _manipularPagamentoI;
  RxList<Venda> lista = RxList();
  List<Venda> listaCopia = [];
  int indiceTabActual = 0;
  var totalDividasPagas = 0.0.obs;
  var totalDividasNaoPagas = 0.0.obs;

  PainelDividasEncomendasC(this.funcionario, this.painelFuncionarioC) {
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

  late Funcionario funcionario;

  Future pegarTotalDividas() async {
    var hoje = DateTime.now();
    var res = await _manipularVendaI.pegarListaTodasPagamentoDividas(hoje);
    for (var cada in res) {
      totalDividasPagas.value += cada.valor ?? 0;
    }
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

  Future pegarLista() async {
    var res = <Venda>[];
    if (painelFuncionarioC.painelActual.value.indicadorPainel ==
        PainelActual.DIVIDAS_GERAIS) {
      res = await _manipularVendaI.pegarListaTodasDividas(funcionario);
    }
    if (painelFuncionarioC.painelActual.value.indicadorPainel ==
        PainelActual.ENCOMENDAS_GERAIS) {
      res = await _manipularVendaI.pegarListaTodasEncomendas(funcionario);
    }

    for (var cada in res) {
      lista.add(cada);
      var emFalta = (cada.total ?? 0) - (cada.parcela ?? 0);
      totalDividasNaoPagas.value += emFalta;
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  mostraDialogoEntregarEncomenda(Venda venda) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
      accaoAoCancelar: () {
        voltar();
      },
      accaoAoConfirmar: () async {
        await entregarEncomenda(venda);
      },
      corButaoSim: primaryColor,
      pergunta: "Deseja mesmo finalizar esta encomenda?",
    ));
  }

  Future<void> entregarEncomenda(Venda venda) async {
    if (venda.divida == true) {
      mostrarDialogoDeInformacao(
          "Ainda tem ${formatar(venda.total! - venda.parcela!)} KZ por pagar!");
      return;
    }
    lista.removeWhere((element) => element.id == venda.id);
    voltar();
    await _manipularVendaI.entregarEncomenda(venda);
  }

  void mostrarFormasPagamento(Venda venda, BuildContext context,
      {bool? comPagamentoFinal}) async {
    if (venda.divida == false) {
      mostrarSnack("Está tudo pago!");
      return;
    }
    mostrarDialogoDeLayou(
        FutureBuilder<List<FormaPagamento>>(
            future: _manipularPagamentoI.pegarListaFormasPagamento(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text("Nenhuma Forma de Pagamento!"),
                );
              }
              var lista = snapshot.data!.map((e) => e.descricao!).toList();
              return LayoutFormaPagamento(
                  accaoAoFinalizar: (valor, opcao) async {
                    await adicionarValorPagamento(venda, valor, opcao);
                  },
                  titulo: "Selecione a Forma de Pagamento",
                  listaItens: lista);
            }),
        naoFechar: true);
  }

  Future<void> adicionarValorPagamento(
      Venda venda, String valor, String? opcao) async {
    if (((venda.parcela ?? 0) + double.parse(valor)) > venda.total!) {
      mostrarDialogoDeInformacao("""Valor demasiado alto!""");
      return;
    }
    voltar();
    var forma = (await _manipularPagamentoI.pegarListaFormasPagamento())
        .firstWhere((element) => element.descricao == opcao);
    var novoPagamento = Pagamento(
        idVenda: venda.id,
        idParaVista: gerarIdUnico(),
        idFormaPagamento: forma.id,
        formaPagamento: forma,
        estado: Estado.ATIVADO,
        valor: double.parse(valor));
    venda.pagamentos ??= [];
    venda.pagamentos!.add(novoPagamento);
    venda.parcela = venda.parcela! + double.parse(valor);

    var hoje = DateTime.now();
    var id = await _manipularPagamentoI.registarPagamento(novoPagamento);
    var pagamentoFinal =
        PagamentoFinal(estado: Estado.ATIVADO, idPagamento: id, data: hoje);
    novoPagamento.pagamentoFinal = pagamentoFinal;

    await _manipularPagamentoI.registarPagamentoFinal(pagamentoFinal);

    totalDividasPagas.value += novoPagamento.valor ?? 0;
    totalDividasNaoPagas.value -= novoPagamento.valor ?? 0;

    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == venda.id) {
        if (lista[i].total == lista[i].parcela) {
          lista.removeAt(i);
        } else {
          lista[i] = venda;
        }
        break;
      }
    }

    await _manipularVendaI.actualizarVenda(venda);
  }

  void mostrarDialogoDetalhesVenda(Venda venda) {
    mostrarDialogoDeLayou(LayoutDetalhesVenda(
      venda: venda,
    ));
  }

  void terminarSessao() {
    painelFuncionarioC.terminarSessao();
  }
}
