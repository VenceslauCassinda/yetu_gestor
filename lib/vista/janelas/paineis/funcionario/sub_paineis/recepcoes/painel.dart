import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/dominio/entidades/receccao.dart';
import 'package:yetu_gestor/vista/componentes/item_receccao.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';
import '../../../../../../dominio/entidades/funcionario.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/item_entrada.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../../../../componentes/tab_bar.dart';
import '../../painel_funcionario_c.dart';
import 'painel_c.dart';

class PainelRecepcoes extends StatelessWidget {
  late RecepcoesC _c;
  late PainelFuncionarioC painelFuncionarioC;
  final Funcionario funcionario;

  PainelRecepcoes(
      {Key? key, required this.funcionario, required this.painelFuncionarioC})
      : super(key: key) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
      _c.funcionario = funcionario;
    } catch (e) {
      _c = Get.put(RecepcoesC(funcionario));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
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
              _c.irParaPainel(PainelActual.INICIO);
            },
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "RECEPÇÕES",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
        Expanded(
          child: Obx(
            () {
              var itens = _c.lista
                  .map((entrada) => ItemRececcao(
                        visaoGeral: false,
                        receccao: entrada,
                        aoClicar: () {},
                      ))
                  .toList();
              if (itens.isEmpty) {
                return Center(child: Text("Sem dados!"));
              }
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                    itemCount: itens.length, itemBuilder: (c, i) => itens[i]),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: ModeloButao(
            corButao: primaryColor,
            corTitulo: Colors.white,
            butaoHabilitado: true,
            tituloButao: "Receber Produto",
            metodoChamadoNoClique: () {
              _c.mostrarDialogoProdutos(context);
            },
          ),
        ),
      ],
    );
  }
}
