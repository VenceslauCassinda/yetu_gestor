import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_receccao_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipula_stock.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_entrada.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_preco.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_produto.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_receccao.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/estado.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/dominio/entidades/receccao.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_entrada.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_preco.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_produto.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_receccao.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_stock.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/produtos/layouts/produtos.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../../gerente/layouts/layout_quantidade.dart';
import '../../../gerente/layouts/layout_receber_completo.dart';

class RecepcoesC extends GetxController {
  late ManipularRececcaoI _manipularRececcaoI;
  late ManipularProduto _manipularProduto;
  var lista = RxList<Receccao>();
  var listaCopia = <Receccao>[];
  late Funcionario funcionario;

  RecepcoesC(this.funcionario) {
    var maipularStock = ManipularStock(ProvedorStock());
    _manipularRececcaoI = ManipularRececcao(
        ProvedorRececcao(), ManipularEntrada(ProvedorEntrada(), maipularStock));
    _manipularProduto = ManipularProduto(
        ProvedorProduto(), maipularStock, ManipularPreco(ProvedorPreco()));
  }
  @override
  void onInit() async {
    await pegarDados();
    super.onInit();
  }

  void aoPesquisar(String f) {
    lista.clear();
    var res = listaCopia;
    for (var cada in res) {
      if ((DateTime(cada.data!.year, cada.data!.month, cada.data!.day))
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.funcionario?.nomeCompelto ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.funcionario?.nomeUsuario ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.produto?.nome ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.quantidade ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  Future<void> pegarDados() async {
    List<Receccao> res = [];
    res = await _manipularRececcaoI.pegarListaRececcoesFuncionario(funcionario);
    for (var cada in res) {
      lista.add(cada);
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  void terminarSessao() {
    PainelFuncionarioC c = Get.find();
    c.terminarSessao();
  }

  void irParaPainel(int indicePainel) {
    PainelFuncionarioC c = Get.find();
    c.irParaPainel(indicePainel);
  }

  var produtos = RxList<Produto>();
  var produtosCopia = RxList<Produto>();
  void aoPesquisarProduto(String f) {
    produtos.clear();
    var res = produtosCopia;
    for (var cada in res) {
      var existe = false;
      for (var cadaParteDado in f.split(" ")) {
        if (cadaParteDado
            .toLowerCase()
            .contains((cada.nome ?? "").toLowerCase())) {
          existe = true;
        }
      }
      if ((cada.nome ?? "")
              .toLowerCase()
              .toString()
              .contains(f.toLowerCase()) ||
          (cada.stock?.quantidade ?? "").toString().contains(f.toLowerCase())) {
        produtos.add(cada);
      }
    }
  }

  void mostrarDialogoProdutos(BuildContext context) async {
    produtos.clear();
    _manipularProduto.pegarLista().then((dado) {
      produtos.addAll(dado);
      produtosCopia.addAll(dado);
    });
    mostrarDialogoDeLayou(Container(
        width: MediaQuery.of(context).size.width * .5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutPesquisa(
                accaoNaInsercaoNoCampoTexto: (dado) {
                  aoPesquisarProduto(dado);
                },
              ),
            ),
            Obx(() {
              produtos.isEmpty;
              return Container(
                height: MediaQuery.of(context).size.height * .5,
                child: LayoutProdutos(
                  lista: produtos,
                  accaoAoClicarCadaProduto: (p) {
                    mostrarDialogoReceber(p);
                  },
                ),
              );
            }),
          ],
        )));
  }

  void mostrarDialogoReceber(Produto produto) {
    voltar();
    mostrarDialogoDeLayou(LayoutQuantidade(
        comOpcaoRetirada: false,
        accaoAoFinalizar: (quantidade, opcaoRetiradaSelecionada) async {
          await _receberProduto(produto, quantidade);
        },
        titulo: "Receber produto ${produto.nome}"));
  }

  Future<void> _receberProduto(Produto produto, String quantidade) async {
    var motivo = Entrada.MOTIVO_ABASTECIMENTO;
    lista.insert(
        0,
        Receccao(
            produto: produto,
            funcionario: funcionario,
            estado: Estado.ATIVADO,
            idFuncionario: funcionario.id,
            idProduto: produto.id,
            quantidade: int.parse(quantidade),
            data: DateTime.now()));
    voltar();
    await _manipularRececcaoI.receberProduto(
        produto, int.parse(quantidade), funcionario, motivo);
  }
}
