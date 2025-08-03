import 'package:flutter/material.dart';
import 'package:novoprojeto/primeiraTela.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Formulario',
      home: FormularioCadastro(),
      theme: ThemeData(useMaterial3: false),
    ),
  );
}
