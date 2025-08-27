import 'package:flutter/material.dart';
import 'package:novoprojeto/app_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const Tela1(), const Tela2()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("My app")),
        actions: const [CustomSwitch()],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela Inicial',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tela 2'),
        ],
      ),
    );
  }
}

class Tela1 extends StatelessWidget {
  const Tela1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Tela Inicial', style: TextStyle(fontSize: 24)),
    );
  }
}

class Tela2 extends StatelessWidget {
  const Tela2({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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

class TabContent extends StatelessWidget {
  final String tabName;
  final Color color;

  const TabContent({super.key, required this.tabName, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: color.withOpacity(0.1),
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
