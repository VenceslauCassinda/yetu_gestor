import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/componentes/validadores/validadcao_campos.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_fincionario.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_usuario.dart';
import 'package:yetu_gestor/dominio/entidades/estado.dart';
import 'package:yetu_gestor/dominio/entidades/nivel_acesso.dart';
import 'package:yetu_gestor/dominio/entidades/sessao.dart';
import 'package:yetu_gestor/dominio/entidades/usuario.dart';
import 'package:yetu_gestor/fonte_dados/erros.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_funcionario.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedores_usuario.dart';
import 'package:yetu_gestor/recursos/constantes.dart';
import 'package:yetu_gestor/vista/aplicacao_c.dart';

import '../../../../contratos/casos_uso/manipular_funcionario_i.dart';
import '../../../../contratos/casos_uso/manipular_usuario_i.dart';

class PainelAdministradorC extends GetxController {
  RxList<Usuario> usuarios = RxList();
  var dadoPesquisado = "".obs;
  var usuario = Rx<Usuario?>(null);
  int indiceTabActual = 0;

  late ManipularFuncionarioI _manipularFuncionarioI;
  late ManipularUsuarioI _manipularUsuarioI;

  @override
  void onInit() async {
    _manipularUsuarioI = ManipularUsuario(ProvedorUsuario());
    _manipularFuncionarioI =
        ManipularFuncionario(_manipularUsuarioI, ProveedorFuncionario());
    await pegarUsuarios();
    super.onInit();
  }

  Future<void> pegarUsuarios() async {
    usuarios.clear();
    for (var element in (await _manipularUsuarioI.todos())) {
      usuarios.add(element);
    }
  }

  Future<void> pegarElimindos() async {
    usuarios.clear();
    for (var element in (await _manipularUsuarioI.pegarListaEliminados())) {
      usuarios.add(element);
    }
  }

  Future<void> pegarActivados() async {
    usuarios.clear();
    for (var element in (await _manipularUsuarioI.todos())) {
      if (element.estado == Estado.ATIVADO) {
        usuarios.add(element);
      }
    }
  }

  Future<void> pegarDesctivados() async {
    usuarios.clear();
    for (var element in (await _manipularUsuarioI.todos())) {
      if (element.estado == Estado.DESACTIVADO) {
        usuarios.add(element);
      }
    }
  }

  Future<void> navegar(int tab) async {
    indiceTabActual = tab;
    if (tab == 0) {
      await pegarUsuarios();
    }
    if (tab == 1) {
      await pegarActivados();
    }
    if (tab == 2) {
      await pegarDesctivados();
    }
    if (tab == 3) {
      await pegarElimindos();
    }
  }

  void actualizarEstado() {
    for (var i = 0; i < usuarios.length; i++) {
      if (usuarios[i].nomeUsuario == usuario.value!.nomeUsuario) {
        usuarios[i] = usuario.value!;
        break;
      }
    }
  }

  void mudar(Usuario? dado) {
    usuario.value = dado;
  }

  Future<void> mostrarDialogoEliminar(Usuario usuario) async {
    mostrarDialogoDeLayou(LayoutConfirmacaoAccao(
        pergunta: "Deseja mesmo eliminar?",
        accaoAoConfirmar: () async {
          await removerUsuario(usuario);
        },
        accaoAoCancelar: () {
          voltar();
        },
        corButaoSim: primaryColor));
  }

  Future<void> removerUsuario(Usuario usuario) async {
    await _manipularUsuarioI.removerUsuarioDefinitivamente(usuario);
    usuarios.removeWhere((element) => element.id == usuario.id);
    voltar();
  }

  Future<void> actualizarUsuario(String nomeUsuario, String palavraPasse,
      String nivelAcesso, String estado, String logado) async {
    if (usuario.value != null) {
      if (ValidacaoCampos.camposVazio(
              [nomeUsuario, palavraPasse, nivelAcesso, estado, logado]) ==
          true) {
        mostrarDialogoDeInformacao("Altere algum dado!");
        return;
      }
      if (nivelAcesso.contains("Seleccionar") ||
          estado.contains("Seleccionar") ||
          logado.contains("Seleccionar")) {
        mostrarDialogoDeInformacao("Preencha todos os campos!");
        return;
      }
      Get.defaultDialog(
          title: "",
          content: LayoutConfirmacaoAccao(
            corButaoSim: primaryColor,
            pergunta: "Deseja mesmo actualizar?",
            accaoAoCancelar: () {
              fecharDialogoCasoAberto();
            },
            accaoAoConfirmar: () async {
              usuario.value!.nomeUsuario = nomeUsuario;
              usuario.value!.nivelAcesso = NivelAcesso.paraInteiro(nivelAcesso);
              usuario.value!.palavraPasse = palavraPasse;
              usuario.value!.estado = Estado.paraInteiro(estado);
              usuario.value!.logado = Sessao.paraBoleano(logado);
              try {
                await _manipularUsuarioI.actualizarUsuario(usuario.value!);
                actualizarEstado();
                fecharDialogoCasoAberto();
              } catch (e) {
                mostrarDialogoDeInformacao((e as Erro).sms);
              }
            },
          ));
    }
  }

  terminarSessao() {
    AplicacaoC.terminarSessao();
  }
}
