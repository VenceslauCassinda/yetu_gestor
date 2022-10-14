import '../../dominio/entidades/definicoes.dart';

abstract class ManipularDefinicoesI {
  Future<Definicoes> pegarDefinicoesActuais();
  Future<void> actualizarDefinicoes(Definicoes dado);
}
