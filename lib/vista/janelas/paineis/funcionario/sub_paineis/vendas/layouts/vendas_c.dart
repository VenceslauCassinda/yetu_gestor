import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_item_venda_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_produto_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_stock_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_pagamento.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/pagamento_final.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/dominio/entidades/venda.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_pagamento.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';
import 'package:yetu_gestor/solucoes_uteis/formato_dado.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/sub_paineis/vendas/layouts/mesa_venda/mesa_venda.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';

import '../../../../../../../contratos/casos_uso/manipular_pagamento_i.dart';
import '../../../../../../../contratos/casos_uso/manipular_venda_i.dart';
import '../../../../../../../dominio/casos_uso/manipula_stock.dart';
import '../../../../../../../dominio/casos_uso/manipular_cliente.dart';
import '../../../../../../../dominio/casos_uso/manipular_item_venda.dart';
import '../../../../../../../dominio/casos_uso/manipular_preco.dart';
import '../../../../../../../dominio/casos_uso/manipular_produto.dart';
import '../../../../../../../dominio/casos_uso/manipular_saida.dart';
import '../../../../../../../dominio/casos_uso/manipular_venda.dart';
import '../../../../../../../dominio/entidades/estado.dart';
import '../../../../../../../dominio/entidades/forma_pagamento.dart';
import '../../../../../../../dominio/entidades/pagamento.dart';
import '../../../../../../../fonte_dados/provedores/provedor_cliente.dart';
import '../../../../../../../fonte_dados/provedores/provedor_item_venda.dart';
import '../../../../../../../fonte_dados/provedores/provedor_preco.dart';
import '../../../../../../../fonte_dados/provedores/provedor_produto.dart';
import '../../../../../../../fonte_dados/provedores/provedor_saida.dart';
import '../../../../../../../fonte_dados/provedores/provedor_stock.dart';
import '../../../../../../../fonte_dados/provedores/provedor_venda.dart';
import '../../../../../../../solucoes_uteis/geradores.dart';
import '../../../../gerente/layouts/layout_forma_pagamento.dart';
import 'detalhes_venda.dart';

class VendasC extends GetxController {
  RxList<Venda> lista = RxList<Venda>();
  List<Venda> listaCopia = <Venda>[];
  RxList<Produto> produtos = RxList<Produto>();
  List<Produto> produtosCopia = <Produto>[];
  late ManipularProdutoI _manipularProdutoI;
  late ManipularStockI _manipularStockI;
  late ManipularVendaI _manipularVendaI;
  late ManipularItemVendaI _manipularItemVendaI;
  late PainelFuncionarioC _painelFuncionarioC;
  late ManipularPagamentoI _manipularPagamentoI;
  int indiceTabActual = 0;
  var totalDividaPagas = 0.0.obs;
  late DateTime data;
  late Funcionario? funcionario;

  VendasC(this.data, this.funcionario) {
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
    try {
      _painelFuncionarioC = Get.find();
    } catch (e) {
      _painelFuncionarioC = Get.put(PainelFuncionarioC());
    }
    await pegarLista();
    pegarTotalDividas();
    super.onInit();
  }

  void terminarSessao() {
    _painelFuncionarioC.terminarSessao();
  }

  void navegar(int indice) async {
    indiceTabActual = indice;
    if (indice == 0) {
      await pegarLista();
    }
    if (indice == 1) {
      await pegarListaVendas();
    }
    if (indice == 2) {
      await pegarListaEncomendas();
    }
    if (indice == 3) {
      await pegarListaDividas();
    }
    await pegarTotalDividas();
  }

  void aoPesquisarVenda(String f) {
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

  void aoPesquisarProduto(String f) {
    produtos.clear();
    var res = produtosCopia;
    for (var cada in res) {
      if (cada.nome!.toLowerCase().contains(f.toLowerCase()) ||
          cada.precoCompra!
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.stock?.quantidade ?? 0)
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ) {
        produtos.add(cada);
      }
    }
  }

  void mostrarDialogoNovaVenda(BuildContext context) {
    mostrarDialogoDeLayou(LayoutMesaVenda(data, funcionario!));
  }

  Future<List<Produto>> pegarListaProdutos() async {
    var res = await _manipularProdutoI.pegarLista();
    for (var cada in res) {
      produtos.add(cada);
    }

    produtosCopia.clear();
    produtosCopia.addAll(produtos);
    return res;
  }

  Future pegarTotalDividas() async {
    var res = await _manipularVendaI.pegarListaTodasPagamentoDividasFuncionario(
        funcionario!, data);
    totalDividaPagas.value = 0;
    for (var cada in res) {
      totalDividaPagas.value += cada.valor ?? 0;
    }
  }

  Future pegarLista() async {
    lista.clear();
    var res = await _manipularVendaI.pegarLista(funcionario, data);
    for (var cada in res) {
      lista.add(cada);
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  Future pegarListaVendas() async {
    lista.clear();
    var res = await _manipularVendaI.pegarListaVendas(funcionario, data);
    for (var cada in res) {
      lista.add(cada);
    }
  }

  Future pegarListaEncomendas() async {
    lista.clear();
    var res = await _manipularVendaI.pegarListaEncomendas(funcionario, data);
    for (var cada in res) {
      lista.add(cada);
    }
  }

  Future pegarListaDividas() async {
    lista.clear();
    var res = await _manipularVendaI.pegarListaDividas(funcionario, data);
    for (var cada in res) {
      lista.add(cada);
    }
  }

  void mostrarDialogoDetalhesVenda(Venda venda) {
    mostrarDialogoDeLayou(LayoutDetalhesVenda(
      venda: venda,
    ));
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
                    await adicionarValorPagamento(venda, valor, opcao,
                        comPagamentoFinal: comPagamentoFinal);
                  },
                  titulo: "Selecione a Forma de Pagamento",
                  listaItens: lista);
            }),
        naoFechar: true);
  }

  Future<void> adicionarValorPagamento(Venda venda, String valor, String? opcao,
      {bool? comPagamentoFinal}) async {
    var soma = (venda.pagamentos ?? []).fold<double>(
        0, (previousValue, element) => element.valor! + previousValue);
    if ((soma + double.parse(valor)) > venda.total!) {
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

    if (comPagamentoFinal != null) {
      await _manipularPagamentoI.registarPagamentoFinal(pagamentoFinal);
    }
    totalDividaPagas.value += double.parse(valor);

    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == venda.id) {
        lista[i] = venda;
        break;
      }
    }
    await _manipularVendaI.actualizarVenda(venda);
  }
}
