import 'package:drift/drift.dart';
import 'package:yetu_gestor/dominio/entidades/item_venda.dart';
import '../../fonte_dados/padrao_dao/base_dados.dart';
import 'cliente.dart';
import 'funcionario.dart';
import 'pagamento.dart';

class Venda {
  Funcionario? funcionario;
  Cliente? cliente;
  List<Pagamento>? pagamentos = [];
  List<ItemVenda>? itensVenda = [];
  int? id;
  int? estado;
  int? idFuncionario;
  int? idCliente;
  DateTime? data;
  DateTime? dataLevantamentoCompra;
  double? total;
  double? parcela;
  bool get divida => (total != parcela);
  bool get encomenda => (data != dataLevantamentoCompra);
  bool get venda => !divida;
  Venda(
      {this.id,
      this.funcionario,
      this.itensVenda,
      this.pagamentos,
      this.cliente,
      required this.estado,
      required this.idFuncionario,
      required this.idCliente,
      required this.data,
      this.dataLevantamentoCompra,
      required this.total,
      required this.parcela});
  factory Venda.fromData(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venda(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<int>(json['estado']),
      idFuncionario: serializer.fromJson<int>(json['idFuncionario']),
      idCliente: serializer.fromJson<int>(json['idCliente']),
      data: serializer.fromJson<DateTime>(json['data']),
      dataLevantamentoCompra:
          serializer.fromJson<DateTime?>(json['dataLevantamentoCompra']),
      total: serializer.fromJson<double>(json['total']),
      parcela: serializer.fromJson<double>(json['parcela']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id!);
    map['estado'] = Variable<int>(estado!);
    map['id_funcionario'] = Variable<int>(idFuncionario!);
    map['id_cliente'] = Variable<int>(idCliente!);
    map['data'] = Variable<DateTime>(data!);
    if (!nullToAbsent || dataLevantamentoCompra != null) {
      map['data_levantamento_compra'] =
          dataLevantamentoCompra as Expression<DateTime>;
    }
    map['total'] = Variable<double>(total!);
    map['parcela'] = Variable<double>(parcela!);
    return map;
  }

  TabelaVendaCompanion toCompanion(bool nullToAbsent) {
    return TabelaVendaCompanion(
      id: id == null ? Value.absent() : Value(id!),
      estado: Value(estado!),
      idFuncionario: Value(idFuncionario!),
      idCliente: Value(idCliente!),
      data: Value(data!),
      dataLevantamentoCompra: dataLevantamentoCompra == null && nullToAbsent
          ? const Value.absent()
          : Value(dataLevantamentoCompra),
      total: Value(total ?? 0),
      parcela: Value(parcela ?? 0),
    );
  }

  factory Venda.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venda(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<int>(json['estado']),
      idFuncionario: serializer.fromJson<int>(json['idFuncionario']),
      idCliente: serializer.fromJson<int>(json['idCliente']),
      data: serializer.fromJson<DateTime>(json['data']),
      dataLevantamentoCompra:
          serializer.fromJson<DateTime?>(json['dataLevantamentoCompra']),
      total: serializer.fromJson<double>(json['total']),
      parcela: serializer.fromJson<double>(json['parcela']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id!),
      'estado': serializer.toJson<int>(estado!),
      'idFuncionario': serializer.toJson<int>(idFuncionario!),
      'idCliente': serializer.toJson<int>(idCliente!),
      'data': serializer.toJson<DateTime>(data!),
      'dataLevantamentoCompra':
          serializer.toJson<DateTime?>(dataLevantamentoCompra!),
      'total': serializer.toJson<double>(total!),
      'parcela': serializer.toJson<double>(parcela!),
    };
  }

  Venda copyWith(
          {int? id,
          int? estado,
          int? idFuncionario,
          int? idCliente,
          int? idPagamento,
          DateTime? data,
          DateTime? dataLevantamentoCompra,
          double? total,
          double? parcela}) =>
      Venda(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        idFuncionario: idFuncionario ?? this.idFuncionario,
        idCliente: idCliente ?? this.idCliente,
        data: data ?? this.data,
        dataLevantamentoCompra:
            dataLevantamentoCompra ?? this.dataLevantamentoCompra,
        total: total ?? this.total,
        parcela: parcela ?? this.parcela,
      );
  @override
  String toString() {
    return (StringBuffer('Venda(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('idFuncionario: $idFuncionario, ')
          ..write('idCliente: $idCliente, ')
          ..write('data: $data, ')
          ..write('dataLevantamentoCompra: $dataLevantamentoCompra, ')
          ..write('total: $total, ')
          ..write(
            'parcela: $parcela',
          )
          ..write('\nCLIENTE: {${cliente?.toString()}}')
          ..write(
              '\nPAGAMENTOS: {${pagamentos?.map((e) => e.toString() + "\n").toList()}}\n')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, estado, idFuncionario, idCliente, data,
      dataLevantamentoCompra, total, parcela);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venda &&
          other.id == id &&
          other.estado == estado &&
          other.idFuncionario == idFuncionario &&
          other.idCliente == idCliente &&
          other.data == data &&
          other.dataLevantamentoCompra == dataLevantamentoCompra &&
          other.total == total &&
          other.parcela == parcela);
}
