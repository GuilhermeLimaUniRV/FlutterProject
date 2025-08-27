import 'package:flutter/material.dart';
import 'package:novoprojeto/app_controller.dart';
import 'package:novoprojeto/tal_login.dart';
import 'package:novoprojeto/tela_home.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.pink,
            brightness: AppController.instance.isThemeDark
                ? Brightness.dark
                : Brightness.light,
          ),
          home: Home(),
        );
      },
    );
  }
}
