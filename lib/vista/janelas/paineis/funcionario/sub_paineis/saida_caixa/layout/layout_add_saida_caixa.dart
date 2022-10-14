import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/label_erros.dart';
import 'package:componentes_visuais/componentes/observadores/observador_butoes.dart';
import 'package:componentes_visuais/componentes/observadores/observador_campo_texto.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../recursos/constantes.dart';

class LayoutAddSaidaCaixa extends StatelessWidget {
  late ObservadorCampoTexto _observadorCampoTexto;
  late ObservadorButoes _observadorButoes = ObservadorButoes();

  final Function(String valor, String motivo) accaoAoFinalizar;

  String? valor;
  String? motivo;
  final String titulo;
  late BuildContext context;
  late String opcaoRetiradaSelecionada;

  LayoutAddSaidaCaixa(
      {required this.accaoAoFinalizar, required this.titulo, valor}) {
    _observadorCampoTexto = ObservadorCampoTexto();
    _observadorButoes = ObservadorButoes();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(100),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titulo,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            CampoTexto(
              textoPadrao: valor,
              context: context,
              campoBordado: false,
              icone: const Icon(Icons.lock),
              tipoCampoTexto: TipoCampoTexto.numero,
              dicaParaCampo: "Valor",
              metodoChamadoNaInsersao: (String novo) {
                valor = novo;
                _observadorCampoTexto.observarCampo(
                    novo, TipoCampoTexto.numero);
                if (novo.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.numero);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao([
                  valor ?? "",
                  motivo ?? ""
                ], [
                  _observadorCampoTexto.valorNumeroValido.value,
                ]);
              },
            ),
            Obx(() {
              return _observadorCampoTexto.valorNumeroValido.value == true
                  ? Container()
                  : LabelErros(
                      sms: "Valor inválido!",
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            CampoTexto(
              context: context,
              campoBordado: false,
              tipoCampoTexto: TipoCampoTexto.nome,
              icone: const Icon(Icons.text_fields),
              dicaParaCampo: "Motivo",
              metodoChamadoNaInsersao: (String valorr) {
                motivo = valorr;
                _observadorCampoTexto.observarCampo(
                    valorr, TipoCampoTexto.nome);
                if (valorr.isEmpty) {
                  _observadorCampoTexto.mudarValorValido(
                      true, TipoCampoTexto.nome);
                }
                _observadorButoes.mudarValorFinalizarCadastroInstituicao(
                    [valor ?? "", motivo ?? ""],
                    [_observadorCampoTexto.valorNomeValido.value]);
              },
            ),
            Obx(() {
              return _observadorCampoTexto.valorNomeValido.value == true
                  ? Container()
                  : LabelErros(
                      sms: "Motivo inválido!",
                    );
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width * .15,
                  child: ModeloButao(
                    tituloButao: "Cancelar",
                    corButao: primaryColor,
                    corTitulo: Colors.white,
                    butaoHabilitado: true,
                    metodoChamadoNoClique: () async {
                      fecharDialogoCasoAberto();
                    },
                  ),
                ),
                Obx(() {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width * .15,
                    child: ModeloButao(
                      corButao: Colors.white.withOpacity(.8),
                      butaoHabilitado: _observadorButoes
                          .butaoFinalizarCadastroInstituicao.value,
                      tituloButao: "Finalizar",
                      metodoChamadoNoClique: () {
                        accaoAoFinalizar(valor!, motivo!);
                      },
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
