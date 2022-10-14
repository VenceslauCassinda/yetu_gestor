import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_saida_caixa_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_saida_caixa.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_saida_caixa.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/layout/layout_add_saida_caixa.dart';

import '../../../../../../dominio/entidades/estado.dart';
import '../../../../../../dominio/entidades/saida_caixa.dart';

class PainelSaidaCaixaC extends GetxController {
  late Funcionario funcionario;

  late ManipularSaidaCaixaI _manipularSaidaCaixaI;

  PainelSaidaCaixaC(this.funcionario) {
    _manipularSaidaCaixaI = ManipularSaidaCaixa(ProvedorSaidaCaixa());
  }

  RxList<SaidaCaixa> lista = RxList();
  List<SaidaCaixa> listaCopia = [];
  @override
  void onInit() {
    pegarDados();
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
              .toLowerCase()
              .toString()
              .contains(f.toLowerCase()) ||
          (cada.funcionario?.nomeUsuario ?? "")
              .toLowerCase()
              .toString()
              .contains(f.toLowerCase()) ||
          (cada.valor ?? "").toString().contains(f.toLowerCase()) ||
          (cada.motivo ?? "")
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  void mostrarDialogoNovaValor(BuildContext context) {
    mostrarDialogoDeLayou(LayoutAddSaidaCaixa(
        accaoAoFinalizar: (valor, motivo) async {
          await adincionarSaida(valor, motivo);
        },
        titulo: "Adicione nova saída!"));
  }

  Future pegarDados() async {
    var res = await _manipularSaidaCaixaI.pegarLista();
    for (var cada in res) {
      lista.add(cada);
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  Future<void> adincionarSaida(String valor, String motivo) async {
    var v = double.parse(valor);
    voltar();
    var saida = SaidaCaixa(
        estado: Estado.ATIVADO,
        funcionario: funcionario,
        idFuncionario: funcionario.id,
        valor: v,
        data: DateTime.now(),
        motivo: motivo);
    var id = await _manipularSaidaCaixaI.adicionarSaidaCaixa(saida);
    saida.id = id;
    lista.insert(0, saida);
  }

  void removerSaida(SaidaCaixa element) async {
    voltar();
    lista.removeWhere((element1) => element1.id == element.id);
    await _manipularSaidaCaixaI.removerSaidaCaixaDeId(element.id!);
  }

  void mostrarDialodoRemover(SaidaCaixa element) {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
      accaoAoCancelar: () {
        voltar();
      },
      accaoAoConfirmar: () {
        removerSaida(element);
      },
      corButaoSim: primaryColor,
      pergunta: "Deseja mesmo eliminar esta Saída",
    ));
  }
}
