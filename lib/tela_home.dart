import 'package:flutter/material.dart';
import 'package:novoprojeto/app_controller.dart'; // Manter o AppController

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Controle da aba ativa

  // Lista de telas que serão exibidas com base no índice
  final List<Widget> _screens = [
    const Tela1(), // Tela 1 (Você pode substituir por qualquer widget que desejar)
    const Tela2(), // Tela 2 (O mesmo para essa tela)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("My app")),
        actions: const [CustomSwitch()], // O switch de troca de tema
      ),
      body: _screens[_currentIndex], // Exibe a tela com base no índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Indica qual aba está ativa
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza o índice para a nova aba
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela Inicial', // Aba para a Tela 1
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tela 2', // Aba para a Tela 2
          ),
        ],
      ),
    );
  }
}

// Tela 1
class Tela1 extends StatelessWidget {
  const Tela1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tela Inicial', style: TextStyle(fontSize: 24)),
    );
  }
}

// Tela 2 (Agora com TabBar)
class Tela2 extends StatelessWidget {
  const Tela2({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Definindo 3 abas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tela 2 com TabBar'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.star), text: 'Tab 1'),
              Tab(icon: Icon(Icons.favorite), text: 'Tab 2'),
              Tab(icon: Icon(Icons.settings), text: 'Tab 3'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TabContent(tabName: 'Tab 1', color: Colors.orange),
            TabContent(tabName: 'Tab 2', color: Colors.pink),
            TabContent(tabName: 'Tab 3', color: Colors.purple),
          ],
        ),
      ),
    );
  }
}

// Conteúdo de cada aba
class TabContent extends StatelessWidget {
  final String tabName;
  final Color color;

  const TabContent({super.key, required this.tabName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: color.withOpacity(0.1), // Adicionando um fundo colorido
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 80, color: color),
            const SizedBox(height: 20),
            Text(
              tabName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text('Conteúdo da $tabName', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// CustomSwitch para alternar o tema
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isThemeDark,
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}
