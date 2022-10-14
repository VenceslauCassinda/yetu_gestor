import 'package:yetu_gestor/contratos/casos_uso/manipular_definicoes_i.dart';
import 'package:yetu_gestor/contratos/provedores/provedor_definicoes_i.dart';
import 'package:yetu_gestor/dominio/entidades/definicoes.dart';

class ManipularDefinicoes implements ManipularDefinicoesI {
  final ProvedorDefinicoesI _provedorDefinicoesI;

  ManipularDefinicoes(this._provedorDefinicoesI);

  @override
  Future<void> actualizarDefinicoes(Definicoes dado) async {
    await _provedorDefinicoesI.actualizarDefinicoes(dado);
  }

  @override
  Future<Definicoes> pegarDefinicoesActuais() async {
    return _provedorDefinicoesI.pegarDefinicoesActuais();
  }
}
