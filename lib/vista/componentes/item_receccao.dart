import 'package:flutter/material.dart';
import 'package:yetu_gestor/dominio/entidades/entrada.dart';
import 'package:yetu_gestor/dominio/entidades/receccao.dart';

class ItemRececcao extends StatelessWidget {
  final Receccao receccao;
  final bool visaoGeral;
  final Function aoClicar;
  ItemRececcao({
    Key? key,
    required this.receccao,
    required this.aoClicar,
    required this.visaoGeral,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Produto: ${receccao.produto?.nome ?? "Nenhum"}"),
            Text("Quantidade: ${receccao.quantidade ?? 0}"),
            Text(
                "Data da Entrada: ${receccao.data.toString().replaceAll(" ", " às ").replaceAll(".000", "")}"),
            Visibility(
              visible: visaoGeral == true,
              child: Text(
                  "Recebido por: ${receccao.funcionario?.nomeCompelto ?? "Ninguem"}"),
            ),
          ],
        ),
      ),
    );
  }
}
