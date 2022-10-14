import 'package:intl/intl.dart';

String formatar(double valor) {
  if (valor <= 999) {
    return "$valor".replaceAll(".0", "");
  }
  var f = NumberFormat("#,###,000");
  return f.format(valor);
}
