import 'package:get/get.dart';
import 'package:yetu_gestor/dominio/entidades/saida.dart';
import 'package:yetu_gestor/fonte_dados/padrao_dao/base_dados.dart';

import '../../contratos/provedores/provedor_saida_i.dart';

class ProvedorSaida implements ProvedorSaidaI {
  late SaidaDao _dao;
  ProvedorSaida() {
    _dao = SaidaDao(Get.find());
  }
  @override
  Future<List<Saida>> pegarLista() async {
    return await _dao.todas();
  }

  @override
  Future<int> registarSaida(Saida saida) async {
    return await _dao.adicionarSaida(saida);
  }

  @override
  Future<List<Saida>> pegarListaDoProduto(int idProduto) async {
    return await _dao.todasComProdutoDeId(idProduto);
  }
}
