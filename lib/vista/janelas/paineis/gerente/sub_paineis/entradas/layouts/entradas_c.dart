import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_entrada_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipula_stock.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_entrada.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_entrada.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_stock.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';

class EntradasC extends GetxController {
  late ManipularEntradaI _manipularEntradaI;
  bool visaoGeral;

  var lista = RxList<Entrada>();
  var listaCopia = <Entrada>[];

  EntradasC({required this.visaoGeral}) {
    _manipularEntradaI =
        ManipularEntrada(ProvedorEntrada(), ManipularStock(ProvedorStock()));
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
          (cada.produto?.nome ?? "")
              .toLowerCase()
              .toString()
              .contains(f.toLowerCase()) ||
          (cada.quantidade ?? "").toString().contains(f.toLowerCase()) ||
          (cada.receccao?.funcionario?.nomeCompelto ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.motivo ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  Future pegarDados() async {
    List<Entrada> res = [];
    if (visaoGeral == true) {
      res = await _manipularEntradaI.pegarLista();
    } else {
      PainelGerenteC c = Get.find();
      Produto produto = (c.painelActual.value.valor as Produto);
      res = await _manipularEntradaI.pegarListaDoProduto(produto);
    }
    for (var cada in res) {
      lista.add(cada);
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  void terminarSessao() {
    PainelGerenteC c = Get.find();
    c.terminarSessao();
  }

  void irParaPainel(int indicePainel) {
    PainelGerenteC c = Get.find();
    c.irParaPainel(indicePainel);
  }
}

te(int a) async {
  return await ManipularEntrada(ProvedorEntrada(), ManipularStock(ProvedorStock()))
      .pegarLista();
}
