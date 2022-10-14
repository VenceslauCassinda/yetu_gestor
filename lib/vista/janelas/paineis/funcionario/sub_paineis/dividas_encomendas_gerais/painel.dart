import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/solucoes_uteis/formato_dado.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';

import '../../../../../../../recursos/constantes.dart';
import '../../../../../componentes/item_modelo_venda.dart';
import '../../../../../componentes/pesquisa.dart';
import 'painel_c.dart';

class PainelDividasEncomendas extends StatelessWidget {
  PainelDividasEncomendas({
    Key? key,
    required this.funcionario,
    required this.funcionarioC,
  }) {
    initiC();
  }

  late PainelFuncionarioC funcionarioC;
  late PainelDividasEncomendasC _c;
  final Funcionario funcionario;

  initiC() {
    try {
      _c = Get.find();
      _c.funcionario = funcionario;
      _c.painelFuncionarioC = funcionarioC;
    } catch (e) {
      _c = Get.put(PainelDividasEncomendasC(funcionario, funcionarioC));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 62),
          child: LayoutPesquisa(
            accaoNaInsercaoNoCampoTexto: (dado) {
              _c.aoPesquisar(dado);
            },
            accaoAoSair: () {
              _c.terminarSessao();
            },
            accaoAoVoltar: () {
              funcionarioC.irParaPainel(PainelActual.INICIO);
            },
          ),
        ),
        Visibility(
          visible: funcionarioC.painelActual.value.indicadorPainel ==
              PainelActual.DIVIDAS_GERAIS,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Obx(
              () => Text(
                "DÍVIDAS PAGAS HOJE: ${formatar(_c.totalDividasPagas.value)} KZ",
                style: TextStyle(color: primaryColor, fontSize: 30),
              ),
            ),
          ),
        ),
        Visibility(
          visible: funcionarioC.painelActual.value.indicadorPainel ==
              PainelActual.DIVIDAS_GERAIS,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Obx(
              () => Text(
                "DÍVIDAS NÃO PAGAS: ${formatar(_c.totalDividasNaoPagas.value)} KZ",
                style: TextStyle(color: primaryColor, fontSize: 30),
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () {
              var itens = _c.lista
                  .map((venda) => ItemModeloVenda(
                    permissao: false,
                        c: _c,
                        venda: venda,
                      ))
                  .toList();
              if (itens.isEmpty) {
                return Center(child: Text("Sem Vendas!"));
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    itemCount: itens.length, itemBuilder: (c, i) => itens[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}
