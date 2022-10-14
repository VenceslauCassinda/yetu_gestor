// ignore_for_file: unnecessary_string_interpolations

import 'package:componentes_visuais/componentes/cabecalho_gaveta.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/imagem_circulo.dart';
import 'package:componentes_visuais/componentes/menu_drop_down.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_layout_builder/responsive_layout_builder.dart';
import 'package:yetu_gestor/dominio/entidades/estado.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/vista/janelas/paineis/administrador/painel_administrador_c.dart';

import '../../../../dominio/entidades/nivel_acesso.dart';
import '../../../../dominio/entidades/sessao.dart';
import '../../../../dominio/entidades/usuario.dart';
import 'componentes/gaveta.dart';
import 'sub_paineis/painel_direito.dart';

class PainelAdministrador extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: ((context, size) {
        Get.put(size);
        return Scaffold(
          drawer: size.tablet != null
              ? Container(
                  color: branca,
                  width: MediaQuery.of(context).size.width * .4,
                  child: GavetaNavegacao(
                    linkImagem: "",
                  ),
                )
              : null,
          appBar: size.tablet != null
              ? AppBar(
                  backgroundColor: primaryColor,
                )
              : null,
          body: CorpoAdministrador(),
        );
      }),
    );
  }
}

class CorpoAdministrador extends StatelessWidget {
  late PainelAdministradorC _c;
  TextStyle headerStyle = TextStyle();
  CorpoAdministrador({
    Key? key,
  }) : super(key: key) {
    _c = Get.put(PainelAdministradorC());
  }

  @override
  Widget build(BuildContext context) {
    var tela = Get.find<ScreenSize>();
    if (tela.tablet != null) {
      return PainelDireito(c: _c);
    }
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: GavetaNavegacao(
              linkImagem: "",
            )),
        Expanded(
          flex: 5,
          child: PainelDireito(c: _c),
        ),
      ],
    );
  }
}
