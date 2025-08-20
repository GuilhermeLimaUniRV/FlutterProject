import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Simples "serviço" de autenticação para demo
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

// Singleton simples para acessar no onGenerateRoute
final auth = AuthService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: auth, // reconstrói quando login/logout mudar
      builder: (context, _) {
        return MaterialApp(
          title: 'Rotas Privadas Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: (settings) => AppRouter.generate(settings),
        );
      },
    );
  }
}

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    WidgetBuilder builder;

    // Rotas privadas
    final privateRoutes = <String>{
      '/dashboard',
      '/detalhes',
    };

    bool isPrivate = privateRoutes.contains(settings.name);

    if (isPrivate && !auth.isLoggedIn) {
      // Redireciona para login, preservando rota e argumentos desejados
      builder = (_) => LoginPage(
            redirectTo: settings.name!,
            redirectArgs: settings.arguments,
          );
      return MaterialPageRoute(builder: builder, settings: const RouteSettings(name: '/login'));
    }

    switch (settings.name) {
      case '/':
        builder = (_) => const HomePage();
        break;
      case '/login':
        final args = settings.arguments as Map<String, dynamic>?;
        builder = (_) => LoginPage(
              redirectTo: args != null ? args['redirectTo'] as String? : null,
              redirectArgs: args != null ? args['redirectArgs'] : null,
            );
        break;
      case '/dashboard':
        builder = (_) => const DashboardPage();
        break;
      case '/detalhes':
        builder = (_) => DetalhesPage(
              // Esperamos um Map<String, dynamic> com os dados
              dados: (settings.arguments ?? const <String, dynamic>{})
                  as Map<String, dynamic>,
            );
        break;
      default:
        builder = (_) => const Scaffold(
              body: Center(child: Text('Rota não encontrada')),
            );
    }

    return MaterialPageRoute(builder: builder, settings: settings);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = {
      'nomeCompleto': 'Ana Beatriz Souza',
      'dataNascimento': '1995-07-21',
      'telefone': '(11) 91234-5678',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Pública)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                auth.isLoggedIn ? 'Autenticado' : 'Anônimo',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: Icon(auth.isLoggedIn ? Icons.logout : Icons.login),
            tooltip: auth.isLoggedIn ? 'Sair' : 'Entrar',
            onPressed: () {
              if (auth.isLoggedIn) {
                auth.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout realizado')),
                );
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Exemplo de Rotas:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
            child: const Text('Ir para /dashboard (PRIVADA)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/detalhes',
                arguments: userData, // Passando o Map na navegação
              );
            },
            child: const Text('Ir para /detalhes (PRIVADA, com Map)'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Ir para /login (PÚBLICA)'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Dica: tente acessar as rotas privadas estando deslogado(a). '
            'Você será redirecionado(a) para o login e, ao logar, voltará '
            'automaticamente para a rota desejada.',
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.redirectTo, this.redirectArgs});

  final String? redirectTo;
  final Object? redirectArgs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login (Pública)')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Simulação de Login'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.lock_open),
                label: const Text('Entrar'),
                onPressed: () {
                  auth.login();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login realizado')),
                  );

                  // Se havia rota alvo, volta para ela
                  if (redirectTo != null) {
                    Navigator.pushReplacementNamed(
                      context,
                      redirectTo!,
                      arguments: redirectArgs,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Privada)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Bem-vindo(a) ao Dashboard!'),
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  const DetalhesPage({super.key, required this.dados});

  final Map<String, dynamic> dados;

  @override
  Widget build(BuildContext context) {
    final nome = dados['nomeCompleto'] ?? '—';
    final nascimento = dados['dataNascimento'] ?? '—';
    final telefone = dados['telefone'] ?? '—';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes (Privada, com Map)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            title: Text(nome.toString()),
            subtitle: Text('Nascimento: $nascimento\nTelefone: $telefone'),
            leading: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
