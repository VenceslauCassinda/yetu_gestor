import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/tab_bar.dart';
import '../../../../../componentes/pesquisa.dart';
import 'layouts/produtos.dart';
import 'layouts/produtos_c.dart';

class PainelProdutos extends StatelessWidget {
  late ProdutosC _c;
  Function? accaoAoVoltar;
  PainelProdutos({Key? key, this.accaoAoVoltar}) {
    initiC();
  }

  initiC() {
    try {
      _c = Get.find();
    } catch (e) {
      _c = Get.put(ProdutosC());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
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
              accaoAoVoltar!();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            children: [
              Obx(() {
                return Text(
                  "PRODUTOS (${_c.lista.length})",
                  style: TextStyle(color: primaryColor),
                );
              }),
              Spacer(),
              Expanded(
                  child: ModeloTabBar(
                listaItens: ["Todos", "Activos", "Desactivos", "Eliminados"],
                indiceTabInicial: 1,
                accao: (indice) {
                  _c.lista.clear();
                  _c.navegar(indice);
                },
              ))
            ],
          ),
        ),
        Obx(() {
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
          return Container(
              height: MediaQuery.of(context).size.height * .485,
              child: LayoutProdutos(lista: _c.lista, c: _c));
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              // width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 20),
              child: ModeloButao(
                icone: Icons.monetization_on_outlined,
                corButao: primaryColor,
                corTitulo: Colors.white,
                butaoHabilitado: true,
                tituloButao: "Tabela de Preços",
                metodoChamadoNoClique: () {
                  _c.mostrarDialogoGerarRelatorioInvestimento(context);
                },
              ),
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(20),
              child: ModeloButao(
                corButao: primaryColor,
                icone: Icons.add,
                corTitulo: Colors.white,
                butaoHabilitado: true,
                tituloButao: "Adicionar Produto",
                metodoChamadoNoClique: () {
                  _c.mostrarDialogoAdicionarProduto(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
