import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/entradas/layouts/entradas.dart';

import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../../../../componentes/tab_bar.dart';
import 'layouts/saidas.dart';
import 'layouts/saidas_c.dart';

class PainelSaidas extends StatelessWidget {
  late SaidasC _c;
  final bool visaoGeral;
  late PainelGerenteC _painelGerenteC;
  Function? accaoAoVoltar;
  PainelSaidas({Key? key, required this.visaoGeral, this.accaoAoVoltar})
      : super(key: key) {
    initiC();
    _painelGerenteC = Get.find();
  }

  initiC() {
    try {
      _c = Get.find();
      _c.visaoGeral = visaoGeral;
    } catch (e) {
      _c = Get.put(SaidasC(visaoGeral: visaoGeral));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: LayoutPesquisa(
            accaoNaInsercaoNoCampoTexto: (dado) {
              _c.aoPesquisar(dado);
            },
            accaoAoSair: () {
              _c.terminarSessao();
            },
            accaoAoVoltar: () {
              accaoAoVoltar!();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Visibility(
                  visible: !visaoGeral,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      child: const Icon(Icons.arrow_back),
                      onTap: () {
                        _c.irParaPainel(PainelActual.PRODUTOS);
                      },
                    ),
                  )),
              Text(
                "SAÍDAS",
                style: TextStyle(color: primaryColor),
              ),
              Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: [],
                indiceTabInicial: 0,
                accao: (indice) {},
              ))
            ],
          ),
        ),
        Visibility(
            visible: !visaoGeral,
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                  "Produto: ${(_painelGerenteC.painelActual.value.valor == null ? null : (_painelGerenteC.painelActual.value.valor as Produto))?.nome ?? "Sem nome"}"),
            )),
        LayoutSaidas(
          visaoGeral: visaoGeral,
        ),
      ],
    );
  }
}
