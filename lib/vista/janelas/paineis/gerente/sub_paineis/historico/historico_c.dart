import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_venda_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_venda.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_venda.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';
import 'package:yetu_gestor/vista/aplicacao_c.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../contratos/casos_uso/manipular_item_venda_i.dart';
import '../../../../../../contratos/casos_uso/manipular_pagamento_i.dart';
import '../../../../../../contratos/casos_uso/manipular_produto_i.dart';
import '../../../../../../contratos/casos_uso/manipular_stock_i.dart';
import '../../../../../../dominio/casos_uso/manipula_stock.dart';
import '../../../../../../dominio/casos_uso/manipular_cliente.dart';
import '../../../../../../dominio/casos_uso/manipular_item_venda.dart';
import '../../../../../../dominio/casos_uso/manipular_pagamento.dart';
import '../../../../../../dominio/casos_uso/manipular_preco.dart';
import '../../../../../../dominio/casos_uso/manipular_produto.dart';
import '../../../../../../dominio/casos_uso/manipular_saida.dart';
import '../../../../../../fonte_dados/provedores/provedor_cliente.dart';
import '../../../../../../fonte_dados/provedores/provedor_item_venda.dart';
import '../../../../../../fonte_dados/provedores/provedor_pagamento.dart';
import '../../../../../../fonte_dados/provedores/provedor_preco.dart';
import '../../../../../../fonte_dados/provedores/provedor_produto.dart';
import '../../../../../../fonte_dados/provedores/provedor_saida.dart';
import '../../../../../../fonte_dados/provedores/provedor_stock.dart';

class HistoricoC extends GetxController {
  late ManipularProdutoI _manipularProdutoI;
  late ManipularStockI _manipularStockI;
  late ManipularVendaI _manipularVendaI;
  late ManipularItemVendaI _manipularItemVendaI;
  late PainelGerenteC _painelGerenteC;
  late ManipularPagamentoI _manipularPagamentoI;

  Funcionario? funcionario;

  RxList<DateTime> lista = RxList();
  List<DateTime> listaCopia = [];
  HistoricoC(this.funcionario) {
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
    super.onInit();
  }

  void aoPesquisar(String f) {
    lista.clear();
    var res = listaCopia;
    for (var cada in res) {
      if ((DateTime(cada.year, cada.month, cada.day))
          .toString()
          .toLowerCase()
          .contains(f.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  Future<List<DateTime>> pegarLista() async {
    var res = [];
    if (funcionario != null) {
      res =
          await _manipularVendaI.pegarListaDataVendasFuncionario(funcionario!);
    } else {
      res = await _manipularVendaI.pegarListaDataVendas();
    }
    for (var cada in res) {
      lista.add(cada);
    }
    listaCopia.clear();
    listaCopia.addAll(lista);
    return lista;
  }

  void terminarSessao() {
    PainelGerenteC c = Get.find();
    c.terminarSessao();
  }

  void seleccionarData(DateTime data, {Funcionario? funcionario}) {
    PainelGerenteC c = Get.find();
    c.irParaPainel(PainelActual.VENDAS_ANTIGA, valor: [data, funcionario]);
  }

  void mostrarDialogoApagarAntes(BuildContext context) async {
    var data = await showDatePicker(
        context: context,
        // locale: const Locale("pt", "PT"),
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (data != null) {
      mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
          pergunta:
              "Deseja mesmo apagar as vendas feitas antes de ${formatarMesOuDia(data.day)}/${formatarMesOuDia(data.month)}/${data.year}?",
          accaoAoConfirmar: () async {
            await _removerAntesData(data);
          },
          accaoAoCancelar: () {},
          corButaoSim: primaryColor));
    }
  }

  Future<void> _removerAntesData(DateTime data) async {
    lista.removeWhere((cada) => cada.isBefore(data));
    voltar();
    await _manipularVendaI.removerVendasAntesData(data);
  }

  void mostrarDialogoApagarTudo(BuildContext context) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo apagar todas as vendas feitas?",
        accaoAoConfirmar: () async {
          await _removerTodas();
        },
        accaoAoCancelar: () {},
        corButaoSim: primaryColor));
  }

  Future<void> _removerTodas() async {
    lista.clear();
    voltar();
    await _manipularVendaI.removerTodasVendas();
  }
}
