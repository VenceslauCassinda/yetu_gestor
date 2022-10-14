import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/solucoes_uteis/formato_dado.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';

import '../../../../../../../recursos/constantes.dart';
import '../../../../../componentes/item_modelo_venda.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../painel_gerente_c.dart';
import 'painel_c.dart';

class PainelDividas extends StatelessWidget {
  PainelDividas({
    Key? key,
    required this.gerenteC,
  }) {
    initiC();
  }

  late PainelGerenteC gerenteC;
  late PainelDividasC _c;

  initiC() {
    try {
      _c = Get.find();
      _c.gerenteC = gerenteC;
    } catch (e) {
      _c = Get.put(PainelDividasC(gerenteC));
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
              gerenteC.irParaPainel(PainelActual.INICIO);
            },
          ),
        ),
        Visibility(
          visible: gerenteC.painelActual.value.indicadorPainel ==
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
          visible: gerenteC.painelActual.value.indicadorPainel ==
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
              if (_c.lista.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(child: Text("Sem Dados!")),
                  ],
                );
              }
              var itens = _c.lista
                  .map((venda) => ItemModeloVenda(
                        permissao: false,
                        c: _c,
                        venda: venda,
                      ))
                  .toList();
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
