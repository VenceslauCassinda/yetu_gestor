import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/nivel_acesso.dart';
import 'package:yetu_gestor/vista/componentes/item_saida_caixa.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/painel_c.dart';

import '../../../../../../dominio/entidades/painel_actual.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/item_dinheiro_sobra.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../painel_funcionario_c.dart';

class PainelSaidaCaixa extends StatelessWidget {
  late Funcionario funcionario;
  late var c;
  late PainelSaidaCaixaC saidaCaixaC;
  Function? accaoAoVoltar;

  PainelSaidaCaixa(this.c, this.funcionario, {this.accaoAoVoltar}) {
    iniciarDependencias();
  }

  void iniciarDependencias() {
    try {
      saidaCaixaC = Get.find();
      saidaCaixaC.funcionario = funcionario;
    } catch (e) {
      saidaCaixaC = Get.put(PainelSaidaCaixaC(funcionario));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 62),
          child: LayoutPesquisa(accaoNaInsercaoNoCampoTexto: (dado) {
            saidaCaixaC.aoPesquisar(dado);
          }, accaoAoSair: () {
            c.terminarSessao();
          }, accaoAoVoltar: () {
            if (accaoAoVoltar != null) {
              accaoAoVoltar!();
              return;
            }
            c.irParaPainel(PainelActual.INICIO);
          }),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: const Text(
            "Saídas de Caixa",
            style: TextStyle(color: primaryColor, fontSize: 30),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx((() {
              return ListView.builder(
                  itemCount: saidaCaixaC.lista.length,
                  itemBuilder: (c, i) => ItemSaidaCaixa(
                        saidaCaixa: saidaCaixaC.lista[i],
                        aoClicar: () {},
                        aoRemover: () {
                          saidaCaixaC
                              .mostrarDialodoRemover(saidaCaixaC.lista[i]);
                        },
                        visaoGeral:
                            funcionario.nivelAcesso == NivelAcesso.GERENTE,
                      ));
            })),
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: ModeloButao(
            corButao: primaryColor,
            corTitulo: Colors.white,
            butaoHabilitado: true,
            tituloButao: "Nova Saída",
            metodoChamadoNoClique: () {
              saidaCaixaC.mostrarDialogoNovaValor(context);
            },
          ),
        )
      ],
    );
  }
}
