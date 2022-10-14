import 'package:drift/drift.dart';

class TabelaRececcao extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get estado => integer()();
  IntColumn get idFuncionario => integer()();
  IntColumn get idProduto => integer()();
  IntColumn get quantidade => integer()();
  DateTimeColumn get data => dateTime()();
}
