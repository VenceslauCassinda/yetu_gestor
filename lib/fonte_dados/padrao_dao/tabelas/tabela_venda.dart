import 'package:drift/drift.dart';

class TabelaVenda extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get estado => integer()();
  IntColumn get idFuncionario => integer()();
  IntColumn get idCliente => integer()();
  DateTimeColumn get data => dateTime()();
  DateTimeColumn get dataLevantamentoCompra => dateTime().nullable()();
  RealColumn get total => real()();
  RealColumn get parcela => real()();
}