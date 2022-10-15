import 'dart:async';

import 'package:componentes_visuais/componentes/butoes.dart';
import 'package:componentes_visuais/componentes/campo_texto.dart';
import 'package:componentes_visuais/componentes/icone_item.dart';
import 'package:componentes_visuais/componentes/layout_confirmacao_accao.dart';
import 'package:componentes_visuais/componentes/modelo_item_lista.dart';
import 'package:componentes_visuais/dialogo/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_entrada_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_funcionario_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_produto_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_receccao_i.dart';
import 'package:yetu_gestor/contratos/casos_uso/manipular_saida_i.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipula_stock.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_entrada.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_preco.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_produto.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_receccao.dart';
import 'package:yetu_gestor/dominio/casos_uso/manipular_saida.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/painel_actual.dart';
import 'package:yetu_gestor/dominio/entidades/preco.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';
import 'package:yetu_gestor/dominio/entidades/saida.dart';
import 'package:yetu_gestor/dominio/entidades/stock.dart';
import 'package:yetu_gestor/dominio/entidades/venda.dart';
import 'package:yetu_gestor/fonte_dados/erros.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_entrada.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_funcionario.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_preco.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_produto.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedor_receccao.dart';
import 'package:yetu_gestor/fonte_dados/provedores/provedores_usuario.dart';
import 'package:yetu_gestor/solucoes_uteis/console.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/layouts/layout_receber_completo.dart';
import 'package:yetu_gestor/vista/janelas/paineis/gerente/painel_gerente_c.dart';

import '../../../../../../../contratos/casos_uso/manipular_entidade_i.dart';
import '../../../../../../../contratos/casos_uso/manipular_stock_i.dart';
import '../../../../../../../dominio/casos_uso/manipular_entidade.dart';
import '../../../../../../../dominio/casos_uso/manipular_fincionario.dart';
import '../../../../../../../dominio/casos_uso/manipular_usuario.dart';
import '../../../../../../../dominio/entidades/caixa.dart';
import '../../../../../../../dominio/entidades/estado.dart';
import '../../../../../../../dominio/entidades/pdf_page.dart';
import '../../../../../../../dominio/entidades/relatorio.dart';
import '../../../../../../../fonte_dados/provedores/provedor_entidade.dart';
import '../../../../../../../fonte_dados/provedores/provedor_saida.dart';
import '../../../../../../../fonte_dados/provedores/provedor_stock.dart';
import '../../../../../../../recursos/constantes.dart';
import '../../../../../../../solucoes_uteis/formato_dado.dart';
import '../../../../../../../solucoes_uteis/pdf_api/investimento_pdf.dart';
import '../../../../../../../solucoes_uteis/pdf_api/pdf_api.dart';
import '../../../../../../../solucoes_uteis/pdf_api/precos_pdf.dart';
import '../../../../../../aplicacao_c.dart';
import '../../../layouts/layout_precos.dart';
import '../../../layouts/layout_produto.dart';
import '../../../layouts/layout_quantidade.dart';

class ProdutosC extends GetxController {
  var lista = RxList<Produto>();
  var listaCopia = <Produto>[];
  late ManipularProdutoI _manipularProdutoI;
  late ManipularStockI _manipularStockI;
  late ManipularRececcaoI _manipularRececcaoI;
  late ManipularFuncionarioI _manipularFuncionarioI;
  late ManipularSaidaI _manipularSaidaI;
  var indiceTabActual = 1.obs;
  late ManipularEntidadeI _manipularEntidadeI;
  late ManipularEntradaI _manipularEntradaI;
  String filtro = "";
  ProdutosC() {
    _manipularEntidadeI = ManipularEntidade(ProvedorEntidade());
    _manipularStockI = ManipularStock(ProvedorStock());
    _manipularProdutoI = ManipularProduto(
        ProvedorProduto(), _manipularStockI, ManipularPreco(ProvedorPreco()));
    _manipularEntradaI = ManipularEntrada(ProvedorEntrada(), _manipularStockI);
    _manipularRececcaoI = ManipularRececcao(
        ProvedorRececcao(), _manipularEntradaI, _manipularProdutoI);
    _manipularFuncionarioI = ManipularFuncionario(
        ManipularUsuario(ProvedorUsuario()), ProveedorFuncionario());
    _manipularSaidaI = ManipularSaida(ProvedorSaida(), _manipularStockI);
  }

  @override
  void onInit() async {
    navegar(1);
    super.onInit();
  }

  void aoPesquisar(String f) {
    lista.clear();
    var res = listaCopia;
    for (var cada in res) {
      if (cada.nome!.toLowerCase().contains(f.toLowerCase()) ||
          cada.precoCompra!
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase()) ||
          (cada.stock?.quantidade ?? 0)
              .toString()
              .toLowerCase()
              .contains(f.toLowerCase())) {
        lista.add(cada);
      }
    }
  }

  Future<List<Produto>> pegarTodos() async {
    var res = await _manipularProdutoI.pegarLista();
    lista.addAll(res);
    listaCopia.clear();
    listaCopia.addAll(lista);
    lista.forEach((element) {
      element.estado ??= Estado.ATIVADO;
    });
    return lista;
  }

  Future<void> pegarActivos() async {
    var res = await _manipularProdutoI.pegarLista();
    lista.clear();
    for (var cada in res) {
      if (cada.estado == Estado.ATIVADO) {
        lista.add(cada);
      }
    }
    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  Future<void> pegarDesactivos() async {
    var res = await _manipularProdutoI.pegarLista();
    for (var cada in res) {
      if (cada.estado == Estado.DESACTIVADO) {
        lista.add(cada);
      }
    }
    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  Future<void> pegarElimindados() async {
    var res = await _manipularProdutoI.pegarLista();
    for (var cada in res) {
      if (cada.estado == Estado.ELIMINADO) {
        lista.add(cada);
      }
    }

    listaCopia.clear();
    listaCopia.addAll(lista);
  }

  Future<void> navegar(int tab) async {
    indiceTabActual.value = tab;
    // Timer.periodic(Duration(seconds: 1), (t) async {
    if (tab == 0) {
      await pegarTodos();
    }
    if (tab == 1) {
      await pegarActivos();
    }
    if (tab == 2) {
      await pegarDesactivos();
    }
    if (tab == 3) {
      await pegarElimindados();
    }
    //   t.cancel();
    // });
  }

  void mostrarDialogoAdicionarProduto(BuildContext context) {
    mostrarDialogoDeLayou(LayoutProduto(
      accaoAoFinalizar: (nome, precoCompra) async {
        fecharDialogoCasoAberto();
        await _adicionarProduto(nome, precoCompra);
      },
    ));
  }

  void mostrarDialogoGerarRelatorioInvestimento(BuildContext context) async {
    var entidades = await _manipularEntidadeI.todos();
    if (entidades.isEmpty) {
      mostrarDialogoDeInformacao("Por favor! Insira os dados da Entidade");
      return;
    }
    List<List<String>> listaItens = [];
    mostrarDialogoDeLayou(Container(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width * .6,
        child: PdfPage(
          nomeRelatorio: "Preços",
          accaoAoCriarPdf: () async {
            double total = 0;
            var hoje = DateTime.now();
            var todos = await _manipularProdutoI.pegarLista();
            for (var cada in todos) {
              listaItens.add([
                (cada.nome ?? "NÃO CONSIDERADO"),
                // "${formatar(cada.preco?.preco ?? 0)} KZ",
              ]);
              total += (cada.precoCompra ?? 0) * (cada.stock?.quantidade ?? 0);
            }

            var realtorio = Relatorio(
                nomeRelatorio: "Relatório de Preços",
                listaItens: listaItens,
                caixa: Caixa(
                    caixaDigital: "caixaDigital",
                    caixaFisico: "caixaFisico",
                    caixaFisicoAcomulado: "caixaFisicoAcomulado",
                    caixaDigitalAcomulado: "caixaDigitalAcomulado",
                    totalDespesas: "totalDespesas"),
                data: hoje,
                nomeEmpresa: entidades[0].nome!,
                enderecoEmpresa: entidades[0].endereco!,
                nifEmpresa: entidades[0].nif!);

            try {
              var pdfFile = await PrecosPdf.generate(realtorio.toInvoice(hoje),
                  cabecalho: [
                    "Nome do Produto",
                    "Preço",
                  ]);
              voltar();
              PdfApi.openFile(pdfFile);
            } catch (e) {
              mostrarDialogoDeInformacao(
                  "O arquivo ainda está aberto noutro programa!\nPor favor feche!");
            }
          },
        )));
  }

  // void mostrarDialogoReceber(Produto produto) {
  //   mostrarDialogoDeLayou(LayoutQuantidade(
  //       comOpcaoRetirada: false,
  //       accaoAoFinalizar: (int quantidade, String? opcao) async {
  //         var motivo = Entrada.MOTIVO_ABASTECIMENTO;
  //         // fecharDialogoCasoAberto();
  //         // await _receberProduto(produto, quantidadePorLotes, quantidadeLotes,
  //         //   precoLote, custo, motivo);
  //       },
  //       titulo: "Receber produto ${produto.nome}"));
  // }

  void mostrarDialogoReceberCompleto(Produto produto) {
    mostrarDialogoDeLayou(LayoutReceberCompleto(
        comOpcaoRetirada: false,
        accaoAoFinalizar: (int quantidadePorLotes, int quantidadeLotes,
            precoLote, double custo, bool pagavel) async {
          var motivo = Entrada.MOTIVO_ABASTECIMENTO;
          fecharDialogoCasoAberto();
          await _receberProduto(produto, quantidadePorLotes, quantidadeLotes,
              precoLote, custo, motivo, pagavel);
        },
        titulo: "Receber produto ${produto.nome}"));
  }

  Future<void> _receberProduto(
      Produto produto,
      int quantidadePorLotes,
      int quantidadeLotes,
      double precoLote,
      double custo,
      String motivo,
      bool pagavel) async {
    AplicacaoC aplicacaoC = Get.find();
    var funcionario = await _manipularFuncionarioI
        .pegarFuncionarioDoUsuarioDeId((aplicacaoC.pegarUsuarioActual())!.id!);
    await _manipularRececcaoI.receberProduto(produto, quantidadePorLotes,
        quantidadeLotes, precoLote, custo, funcionario, motivo, pagavel);
    _somarQuantidadeProduto(
      produto,
      quantidadePorLotes * quantidadeLotes,
    );
    _actualizarPrecoCompraProduto(
      produto,
      ((precoLote * quantidadeLotes) + custo) ~/
          (quantidadePorLotes * quantidadeLotes),
    );
  }

  void mostrarDialogoAumentar(Produto produto) {
    mostrarDialogoDeLayou(LayoutQuantidade(
        comOpcaoRetirada: false,
        accaoAoFinalizar: (quantidade, o) async {
          var motivo = Entrada.MOTIVO_AJUSTE_STOCK;
          fecharDialogoCasoAberto();
          await _manipularEntradaI.registarEntrada(Entrada(
              produto: produto,
              estado: Estado.ATIVADO,
              idProduto: produto.id,
              idRececcao: -1,
              quantidade: quantidade,
              data: DateTime.now(),
              motivo: motivo));
        },
        titulo: "Aumentar quantidade do produto ${produto.nome}"));
  }

  void mostrarDialogoRetirar(Produto produto) {
    mostrarDialogoDeLayou(LayoutQuantidade(
        comOpcaoRetirada: true,
        accaoAoFinalizar: (quantidade, opcaoRetiradaSelecionada) async {
          fecharDialogoCasoAberto();
          await _retirarProduto(produto, quantidade, opcaoRetiradaSelecionada!);
        },
        titulo: "Retirar quantidade do produto ${produto.nome}"));
  }

  void _somarQuantidadeProduto(Produto produto, int quantidade) {
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == produto.id) {
        produto.stock!.quantidade =
            ((lista[i].stock!.quantidade! + quantidade));
        lista[i] = produto;
        break;
      }
    }
  }

  void _actualizarPrecoCompraProduto(Produto produto, int novoPrecoCompra) {
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == produto.id) {
        produto.precoCompra = novoPrecoCompra.toDouble();
        lista[i] = produto;
        break;
      }
    }
  }

  void _subtrairQuantidadeProduto(Produto produto, int quantidade) {
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == produto.id) {
        produto.stock!.quantidade =
            ((lista[i].stock!.quantidade! - quantidade));
        lista[i] = produto;
        break;
      }
    }
  }

  void _alterarProduto(Produto produto) {
    for (var i = 0; i < lista.length; i++) {
      if (lista[i].id == produto.id) {
        lista[i] = produto;
        break;
      }
    }
  }

  void mostrarDialogoActualizarProduto(Produto produto) {
    mostrarDialogoDeLayou(LayoutProduto(
      produto: produto,
      accaoAoFinalizar: (nome, precoCompra) async {
        fecharDialogoCasoAberto();
        await _actualizarProduto(nome, precoCompra, produto);
      },
    ));
  }

  void mostrarDialogoPrecosVenda(Produto produto) async {
    RxList<Preco> precos = RxList([]);
    var res = await _manipularProdutoI.pegarPrecoProdutoDeId(produto.id!);
    for (var cada in res) {
      precos.add(Preco(
          estado: cada.estado,
          quantidade: cada.quantidade,
          idProduto: cada.idProduto,
          preco: cada.preco,
          id: cada.id));
    }
    mostrarDialogoDeLayou(
      LayoutPrecos(
        produto: produto,
        precos: precos,
        produtosC: this,
      ),
    );
  }

  void adicionarPrecoProduto(Produto produto, Preco preco) async {
    await _manipularProdutoI.adicionarPrecoProduto(
        produto, preco.preco!, preco.quantidade!);
  }

  void removerPrecoProduto(Produto produto, Preco preco) async {
    await _manipularProdutoI.removerPrecoProduto(
        produto, preco.preco!, preco.quantidade!);
  }

  void mostrarDialogoEliminarProduto(Produto produto) {
    mostrarDialogoDeLayou(
        LayoutConfirmacaoAccao(
            corButaoSim: primaryColor,
            pergunta: "Deseja mesmo eliminar o Produto ${produto.nome}",
            accaoAoConfirmar: () async {
              fecharDialogoCasoAberto();
              await _manipularProdutoI.removerProduto(produto);
              await _eliminarProduto(produto);
            },
            accaoAoCancelar: () {}),
        layoutCru: true);
  }

  void recuperarProduto(Produto produto) async {
    _eliminarProduto(produto);
    await _manipularProdutoI.recuperarProduto(produto);
  }

  void activarProduto(Produto produto) async {
    _eliminarProduto(produto);
    await _manipularProdutoI.activarProduto(produto);
  }

  void desactivarProduto(Produto produto) async {
    _eliminarProduto(produto);
    await _manipularProdutoI.desactivarrProduto(produto);
  }

  Future<void> _eliminarProduto(Produto produto) async {
    lista.removeWhere((element) => element.id == produto.id);
    fecharDialogoCasoAberto();
  }

  Future<void> _adicionarProduto(
    String nome,
    String precoCompra,
  ) async {
    try {
      var novoProduto = Produto(
          nome: nome,
          precoCompra: double.parse(precoCompra),
          estado: Estado.ATIVADO);
      lista.insert(0, novoProduto);
      var id = await _manipularProdutoI.adicionarProduto(novoProduto);
      novoProduto.id = id;
      // await _manipularProdutoI.adicionarPrecoProduto(
      //     novoProduto, double.parse(precoVenda));
      novoProduto.stock = Stock.zerado();
    } on Erro catch (e) {
      mostrarDialogoDeInformacao(e.sms);
    }
  }

  Future<void> _actualizarProduto(
      String nome, String precoCompra, Produto produto) async {
    try {
      for (var i = 0; i < lista.length; i++) {
        if (lista[i].id == produto.id) {
          produto.nome = nome;
          produto.precoCompra = double.parse(precoCompra);
          lista[i] = produto;
          await _manipularProdutoI.actualizarProduto(produto);
          // await _manipularProdutoI.atualizarPrecoProduto(
          //     produto, double.parse(precoVenda));
          break;
        }
      }
    } on Erro catch (e) {
      mostrarDialogoDeInformacao(e.sms);
    }
  }

  void terminarSessao() {
    AplicacaoC.terminarSessao();
  }

  Future<void> _retirarProduto(
      Produto produto, int quantidade, String opcaoRetiradaSelecionada) async {
    try {
      var data = DateTime.now();
      await _manipularSaidaI.registarSaida(Saida(
          idProduto: produto.id,
          quantidade: quantidade,
          estado: Estado.ATIVADO,
          data: data,
          motivo: opcaoRetiradaSelecionada));
      _subtrairQuantidadeProduto(produto, quantidade);
    } on Erro catch (e) {
      mostrarDialogoDeInformacao(e.sms);
    }
  }

  void verEntradas(Produto produto) {
    PainelGerenteC c = Get.find();
    c.irParaPainel(PainelActual.ENTRADAS, valor: produto);
  }

  void verSaidas(Produto produto) {
    PainelGerenteC c = Get.find();
    c.irParaPainel(PainelActual.SAIDAS, valor: produto);
  }
}
