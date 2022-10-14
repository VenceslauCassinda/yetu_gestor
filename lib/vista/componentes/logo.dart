import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  final Color cor;
  double? tamanhoTexto;
  Logo({
    Key? key,
    required this.cor,
    this.tamanhoTexto,
  }) : super(key: key);

  get primaryColor => null;

  @override
  Widget build(BuildContext context) {
    return Text(
      "YETUGESTOR",
      style: GoogleFonts.monoton(
          fontWeight: FontWeight.bold,
          fontSize: tamanhoTexto ?? 35.sp,
          color: cor),
    );
  }
}
