import 'package:drift/drift.dart';
import 'package:yetu_gestor/dominio/entidades/funcionario.dart';
import 'package:yetu_gestor/dominio/entidades/produto.dart';

import '../../fonte_dados/padrao_dao/base_dados.dart';

class Receccao {
  Produto? produto;
  Funcionario? funcionario;
  int? id;
  int? estado;
  int? idFuncionario;
  int? idProduto;
  int? quantidade;
  DateTime? data;
  Receccao(
      {this.id,
      required this.estado,
      this.produto,
      this.funcionario,
      required this.idFuncionario,
      required this.idProduto,
      required this.quantidade,
      required this.data});
  factory Receccao.fromData(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receccao(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<int>(json['estado']),
      idFuncionario: serializer.fromJson<int>(json['idFuncionario']),
      idProduto: serializer.fromJson<int>(json['idProduto']),
      quantidade: serializer.fromJson<int>(json['quantidade']),
      data: serializer.fromJson<DateTime>(json['data']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id!);
    map['estado'] = Variable<int>(estado!);
    map['id_funcionario'] = Variable<int>(idFuncionario!);
    map['id_produto'] = Variable<int>(idProduto!);
    map['quantidade'] = Variable<int>(quantidade!);
    map['data'] = Variable<DateTime>(data!);
    return map;
  }

  TabelaRececcaoCompanion toCompanion(bool nullToAbsent) {
    return TabelaRececcaoCompanion(
      estado: Value(estado!),
      idFuncionario: Value(idFuncionario!),
      idProduto: Value(idProduto!),
      quantidade: Value(quantidade!),
      data: Value(data!),
    );
  }

  factory Receccao.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receccao(
      id: serializer.fromJson<int>(json['id']),
      estado: serializer.fromJson<int>(json['estado']),
      idFuncionario: serializer.fromJson<int>(json['idFuncionario']),
      idProduto: serializer.fromJson<int>(json['idProduto']),
      quantidade: serializer.fromJson<int>(json['quantidade']),
      data: serializer.fromJson<DateTime>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id!),
      'estado': serializer.toJson<int>(estado!),
      'idFuncionario': serializer.toJson<int>(idFuncionario!),
      'idProduto': serializer.toJson<int>(idProduto!),
      'quantidade': serializer.toJson<int>(quantidade!),
      'data': serializer.toJson<DateTime>(data!),
    };
  }

  Receccao copyWith(
          {int? id,
          int? estado,
          int? idFuncionario,
          int? idProduto,
          int? quantidade,
          DateTime? data}) =>
      Receccao(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        idFuncionario: idFuncionario ?? this.idFuncionario,
        idProduto: idProduto ?? this.idProduto,
        quantidade: quantidade ?? this.quantidade,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Receccao(')
          ..write('id: $id, ')
          ..write('estado: $estado, ')
          ..write('idFuncionario: $idFuncionario, ')
          ..write('idProduto: $idProduto, ')
          ..write('quantidade: $quantidade, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, estado, idFuncionario, idProduto, quantidade, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TabelaRececcaoData &&
          other.id == this.id &&
          other.estado == this.estado &&
          other.idFuncionario == this.idFuncionario &&
          other.idProduto == this.idProduto &&
          other.quantidade == this.quantidade &&
          other.data == this.data);
}
