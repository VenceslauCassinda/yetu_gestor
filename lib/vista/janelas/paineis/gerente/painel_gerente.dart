// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/painel_funcionario_c.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/sub_paineis/dinheiro_sobra/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/funcionario/sub_paineis/saida_caixa/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/definicoes/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/dividas/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/entradas/painel_entradas.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/investimento/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/pagamentos/painel_pagamentos.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/perfil/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/relatorio/painel.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/sub_paineis/saidas/painel_saidas.dart';

import '../funcionario/sub_paineis/vendas/painel_vendas.dart';
import 'componentes/gaveta.dart';
import 'sub_paineis/funcionarios/painel_direito.dart';
import 'sub_paineis/historico/historico.dart';
import 'sub_paineis/produtos/painel_produtos.dart';

class PainelGerente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CorpoGerente();
  }
}

class CorpoGerente extends StatelessWidget {
  late PainelGerenteC _c;
  TextStyle headerStyle = TextStyle();
  CorpoGerente({
    Key? key,
  }) : super(key: key) {
    _c = Get.put(PainelGerenteC());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(builder: (context, size) {
      Get.put(size);
      return Visibility(
        visible: size.tablet != null,
        child: Scaffold(
          drawer: Container(
            color: branca,
            width: MediaQuery.of(context).size.width * .4,
            child: GavetaNavegacao(
              linkImagem: "",
              c: _c,
            ),
          ),
          appBar: AppBar(backgroundColor: primaryColor),
          body: pegarLayoutPainel(),
        ),
        replacement: Scaffold(
          body: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: GavetaNavegacao(
                    linkImagem: "",
                    c: _c,
                  )),
              Expanded(
                flex: 5,
                child: pegarLayoutPainel(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Obx pegarLayoutPainel() {
    return Obx(() {
      if (_c.painelActual.value.indicadorPainel == PainelActual.PRODUTOS) {
        return PainelProdutos();
      }
      if (_c.painelActual.value.indicadorPainel ==
          PainelActual.ENTRADAS_GERAL) {
        return PainelEntradas(
          visaoGeral: true,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.ENTRADAS) {
        return PainelEntradas(
          visaoGeral: false,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.SAIDAS_GERAL) {
        return PainelSaidas(
          visaoGeral: true,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.SAIDAS) {
        return PainelSaidas(
          visaoGeral: false,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.PAGAMENTOS) {
        return PainelPagamentos();
      }
      if (_c.painelActual.value.indicadorPainel ==
          PainelActual.DIVIDAS_GERAIS) {
        return PainelDividas(
          gerenteC: _c,
        );
      }
      if (_c.painelActual.value.indicadorPainel ==
          PainelActual.VENDAS_FUNCIONARIOS) {
        return PainelHistorico(
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.FUNCIONARIOS);
          },
          c: _c,
          funcionario: _c.painelActual.value.valor as Funcionario,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.VENDAS) {
        return PainelHistorico(
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.FUNCIONARIOS);
          },
          c: _c,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.VENDAS_ANTIGA) {
        return PainelVendas(
          data: (_c.painelActual.value.valor as List)[0] as DateTime,
          funcionario: (_c.painelActual.value.valor as List)[1],
          funcionarioC: PainelFuncionarioC(),
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.VENDAS);
          },
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.SAIDA_CAIXA) {
        return PainelSaidaCaixa(
          _c,
          _c.funcionarioActual,
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.FUNCIONARIOS);
          },
        );
      }
      if (_c.painelActual.value.indicadorPainel ==
          PainelActual.DINHEIRO_SOBRA) {
        return PainelDinheiroSobra(
          c: _c,
          funcionario: _c.funcionarioActual,
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.FUNCIONARIOS);
          },
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.INVESTIMENTO) {
        return PainelInvestimento(
          gerenteC: _c,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.RELATORIO) {
        return PainelRelatorio(
          gerenteC: _c,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.PERFIL) {
        return PainelPerfil(
          _c,
        );
      }
      if (_c.painelActual.value.indicadorPainel == PainelActual.DEFINICOES) {
        return PainelDefinicoes(
          _c,
          _c.funcionarioActual,
          accaoAoVoltar: () {
            _c.irParaPainel(PainelActual.FUNCIONARIOS);
          },
        );
      }
      return PainelDireito(c: _c);
    });
  }
}
