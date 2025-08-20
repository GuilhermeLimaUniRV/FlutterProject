import 'package:flutter/material.dart';
import 'package:novoprojeto/telaHome.dart';

class TelaIncial extends StatelessWidget {
  const TelaIncial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: false),
      home: Home(),
    );
  }
}
