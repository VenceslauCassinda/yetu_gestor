import 'package:flutter/material.dart';
import 'package:yetu_gestor/vista/aplicacao.dart';
import 'package:sqlite3/open.dart';

import 'fonte_dados/padrao_dao/configuracao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Aplicacao());
}
