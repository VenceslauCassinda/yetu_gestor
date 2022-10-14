import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/solucoes_uteis/formato_dado.dart';
import 'package:yetu_gestor/vista/componentes/item_investimento.dart';
import '../../../../../../dominio/entidades/painel_actual.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/tab_bar.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../painel_gerente_c.dart';
import 'painel_c.dart';

class PainelInvestimento extends StatelessWidget {
  late PainelInvestimentoC _c;
  final PainelGerenteC gerenteC;
  PainelInvestimento({
    Key? key,
    required this.gerenteC,
  }) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
    } catch (e) {
      _c = Get.put(PainelInvestimentoC());
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
              gerenteC.irParaPainel(PainelActual.FUNCIONARIOS);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Text(
                "INVESTIMENTO",
                style: TextStyle(color: primaryColor),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Obx(() {
                return Text(
                  "TOTAL DE INVESTIMENTO: ${formatar(_c.totalInvestido.value)} KZ",
                  style: TextStyle(color: primaryColor),
                );
              })
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
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
            return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    itemCount: _c.lista.length,
                    itemBuilder: (c, i) => InkWell(
                          onTap: () {},
                          child: ItemInvestimento(
                            produto: _c.lista[i],
                            c: _c,
                          ),
                        )));
          }),
        ),
      ],
    );
  }
}
