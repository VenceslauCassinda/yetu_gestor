import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';
import 'package:yetu_gestor/solucoes_uteis/formato_dado.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';

import '../../../../../../../recursos/constantes.dart';
import '../../../../../../solucoes_uteis/utils.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../../../../componentes/tab_bar.dart';
import 'layouts/vendas.dart';
import 'layouts/vendas_c.dart';

class PainelVendas extends StatelessWidget {
  PainelVendas({
    Key? key,
    required this.data,
    required this.funcionario,
    required this.funcionarioC,
    this.accaoAoVoltar,
  }) {
    initiC();
  }

  Function? accaoAoVoltar;
  late PainelFuncionarioC funcionarioC;
  late VendasC _c;
  final DateTime data;
  final Funcionario? funcionario;

  initiC() {
    try {
      _c = Get.find();
      _c.data = data;
      _c.funcionario = funcionario;
    } catch (e) {
      _c = Get.put(VendasC(data, funcionario));
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalDividasPagas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 62),
          child: LayoutPesquisa(
            accaoNaInsercaoNoCampoTexto: (dado) {
              _c.aoPesquisarVenda(dado);
            },
            accaoAoSair: () {
              _c.terminarSessao();
            },
            accaoAoVoltar: (accaoAoVoltar != null ||
                    funcionarioC.painelActual.value.valor != null)
                ? () {
                    if (accaoAoVoltar != null) {
                      accaoAoVoltar!();
                      return;
                    }
                    funcionarioC.irParaPainel(PainelActual.HISTORICO_VENDAS);
                  }
                : null,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Text(
            "CAIXA: ${formatar(_c.lista.fold<double>(0, (antigoV, cadaV) => ((cadaV.pagamentos ?? []).fold<double>(0, (antigoP, cadaP) => (cadaP.valor ?? 0) + antigoP)) + antigoV))} KZ",
            style: TextStyle(color: primaryColor, fontSize: 30),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Text(
            "DINHEIRO FÍSICO: ${formatar(_c.lista.fold<double>(0, (antigoV, cadaV) => ((cadaV.pagamentos ?? []).fold<double>(0, (antigoP, cadaP) {
                  if (cadaP.valor == null) {
                    return 0;
                  }
                  if ((cadaP.formaPagamento?.descricao ?? "")
                          .toLowerCase()
                          .contains('CASH'.toLowerCase()) ==
                      true) {
                    return (cadaP.valor ?? 0) + antigoP;
                  }
                  return antigoP;
                }) + antigoV)))} KZ",
            style: const TextStyle(color: primaryColor, fontSize: 30),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Text(
            "DINHEIRO DIGITAL: ${formatar(_c.lista.fold<double>(0, (antigoV, cadaV) => ((cadaV.pagamentos ?? []).fold<double>(0, (antigoP, cadaP) {
                  if (cadaP.valor == null) {
                    return 0;
                  }
                  if ((cadaP.formaPagamento?.descricao ?? "")
                          .toLowerCase()
                          .contains('CASH'.toLowerCase()) ==
                      false) {
                    mostrar(cadaP.formaPagamento?.descricao);
                    mostrar(cadaP.valor);
                    return (cadaP.valor ?? 0) + antigoP;
                  }
                  return antigoP;
                }) + antigoV)))} KZ",
            style: const TextStyle(color: primaryColor, fontSize: 30),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Obx(
            () => Text(
              "DÍVIDAS PAGAS: ${formatar(_c.totalDividaPagas.value)} KZ",
              style: const TextStyle(color: primaryColor, fontSize: 30),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Text(
                "${(data.day == DateTime.now().day && data.month == DateTime.now().month && data.year == DateTime.now().year) ? "HOJE" : "DATA"} - ${formatarMesOuDia(data.day)}/${formatarMesOuDia(data.month)}/${data.year}",
                style: TextStyle(color: primaryColor),
              ),
              const Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: ["TODAS", "VENDAS", "ENCOMENDAS", "DÍVIDAS"],
                indiceTabInicial: 0,
                accao: (indice) {
                  _c.navegar(indice);
                },
              ))
            ],
          ),
        ),
        Expanded(
          child: LayoutVendas(visaoGeral: true),
        ),
        Container(
          // width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(20),
          child: ModeloButao(
            corButao: primaryColor,
            corTitulo: Colors.white,
            butaoHabilitado: true,
            tituloButao: "Adicionar Venda",
            metodoChamadoNoClique: () {
              _c.mostrarDialogoNovaVenda(context);
            },
          ),
        ),
      ],
    );
  }
}
