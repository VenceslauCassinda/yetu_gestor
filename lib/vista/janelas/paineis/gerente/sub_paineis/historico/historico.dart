import 'package:componentes_visuais/componentes/formatos/formatos.dart';
import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';

import '../../../../../../recursos/constantes.dart';
import '../../../../../componentes/pesquisa.dart';
import '../../painel_gerente_c.dart';
import 'historico_c.dart';

class PainelHistorico extends StatelessWidget {
  PainelHistorico({
    Key? key,
    required PainelGerenteC c,
    this.funcionario,
    this.accaoAoVoltar,
  })  : _funcionarioC = c,
        super(key: key) {
    initiC();
  }

  late HistoricoC _c;
  final PainelGerenteC _funcionarioC;
  final Funcionario? funcionario;
  Function? accaoAoVoltar;

  initiC() {
    try {
      _c = Get.find();
      _c.funcionario = funcionario;
    } catch (e) {
      _c = Get.put(HistoricoC(funcionario));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              if (accaoAoVoltar != null) {
                accaoAoVoltar!();
              }
              _funcionarioC.irParaPainel(PainelActual.INICIO);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25, bottom: 10, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "DATAS",
                style: TextStyle(color: primaryColor),
              ),
              Spacer(),
              Visibility(
                visible: funcionario == null,
                child: IconeItem(
                    metodoQuandoItemClicado: () {
                      _c.mostrarDialogoApagarAntes(context);
                    },
                    icone: Icons.delete,
                    titulo: "Antes de"),
              ),
              SizedBox(
                width: 40,
              ),
              Visibility(
                visible: funcionario == null,
                child: IconeItem(
                    metodoQuandoItemClicado: () {
                      _c.mostrarDialogoApagarTudo(context);
                    },
                    icone: Icons.delete_sweep,
                    titulo: "Tudo"),
              )
            ],
          ),
        ),
        Obx((() {
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
            height: MediaQuery.of(context).size.height * .72,
            child: ListView.builder(
                itemCount: _c.lista.length,
                itemBuilder: ((context, i) => Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ModeloItemLista(
                        itemComentado: false,
                        metodoChamadoAoClicarItem: () {
                          _c.seleccionarData(_c.lista[i],
                              funcionario: funcionario);
                        },
                        tituloItem:
                            "${formatarMesOuDia(_c.lista[i].day)}/${formatarMesOuDia(_c.lista[i].month)}/${_c.lista[i].year}",
                      ),
                    ))),
          );
        }))
      ],
    );
  }
}
