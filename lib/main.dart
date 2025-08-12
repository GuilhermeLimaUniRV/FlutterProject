import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrossel de Micro-Formulários',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MicroFormsCarouselPage(),
    );
  }
}

class MicroFormData {
  final TextEditingController nameController;
  DateTime? birthDate;
  String? gender;

  MicroFormData({String initialName = '', this.birthDate, this.gender})
    : nameController = TextEditingController(text: initialName);

  void dispose() {
    nameController.dispose();
  }
}

class MicroFormsCarouselPage extends StatefulWidget {
  const MicroFormsCarouselPage({super.key});

  @override
  State<MicroFormsCarouselPage> createState() => _MicroFormsCarouselPageState();
}

class _MicroFormsCarouselPageState extends State<MicroFormsCarouselPage> {
  final _pageController = PageController(viewportFraction: 0.85);
  final List<GlobalKey<FormState>> _formKeys = [];
  final List<MicroFormData> _forms = [];

  @override
  void initState() {
    super.initState();
    _addForm(); // começa com um card
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final f in _forms) {
      f.dispose();
    }
    super.dispose();
  }

  void _addForm() {
    setState(() {
      _forms.add(MicroFormData(gender: null));
      _formKeys.add(GlobalKey<FormState>());
      // anima para o último card após adicionar
      Future.microtask(() {
        if (_forms.length > 1) {
          _pageController.animateToPage(
            _forms.length - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _removeForm(int index) {
    if (_forms.length == 1) return; // mantém pelo menos um
    setState(() {
      _forms[index].dispose();
      _forms.removeAt(index);
      _formKeys.removeAt(index);
    });
  }

  Future<void> _pickDate(int index) async {
    final now = DateTime.now();
    final initial =
        _forms[index].birthDate ??
        DateTime(now.year - 18, now.month, now.day); // sugestão inicial
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: 'Selecione a Data de Nascimento',
      fieldLabelText: 'Data',
      cancelText: 'Cancelar',
      confirmText: 'OK',
    );
    if (picked != null) {
      setState(() {
        _forms[index].birthDate = picked;
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  void _saveAll() {
    // Valida todos os forms visíveis
    bool allValid = true;
    for (int i = 0; i < _formKeys.length; i++) {
      final ok = _formKeys[i].currentState?.validate() ?? false;
      allValid = allValid && ok;
    }
    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Corrija os erros antes de salvar.')),
      );
      return;
    }

    // Coleta dados
    final collected = _forms.map((f) {
      return {
        'nomeCompleto': f.nameController.text.trim(),
        'dataNascimento': f.birthDate?.toIso8601String(),
        'sexo': f.gender,
      };
    }).toList();

    // Exemplo: mostra no console e no SnackBar
    // Em app real, você pode enviar para API, salvar local, etc.
    // ignore: avoid_print
    print(collected);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foram salvos ${collected.length} micro-formulários.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.82;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrossel de Micro-Formulários'),
        actions: [
          IconButton(
            tooltip: 'Salvar tudo',
            onPressed: _saveAll,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addForm,
        label: const Text('Adicionar card'),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _forms.length,
          padEnds: false,
          itemBuilder: (context, index) {
            final data = _forms[index];
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                // Efeito sutil de escala no carrossel
                double scale = 1.0;
                if (_pageController.position.haveDimensions) {
                  final page =
                      _pageController.page ??
                      _pageController.initialPage.toDouble();
                  final diff = (page - index).abs();
                  scale = (1 - (diff * 0.06)).clamp(0.92, 1.0);
                }
                return Center(
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: SizedBox(
                width: cardWidth,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKeys[index],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Cabeçalho do card
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Formulário ${index + 1}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                tooltip: _forms.length == 1
                                    ? 'Não pode remover o único card'
                                    : 'Remover este card',
                                onPressed: _forms.length == 1
                                    ? null
                                    : () => _removeForm(index),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Nome Completo
                          TextFormField(
                            controller: data.nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                              hintText: 'Digite o nome completo',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Informe o nome completo';
                              }
                              if (value.trim().length < 3) {
                                return 'Nome muito curto';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Data de Nascimento (sem pacotes externos)
                          GestureDetector(
                            onTap: () => _pickDate(index),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Data de Nascimento',
                                  hintText: 'DD/MM/AAAA',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                ),
                                controller: TextEditingController(
                                  text: _formatDate(data.birthDate),
                                ),
                                validator: (_) {
                                  if (data.birthDate == null) {
                                    return 'Selecione a data';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sexo (Homem/Mulher)
                          DropdownButtonFormField<String>(
                            value: data.gender,
                            decoration: const InputDecoration(
                              labelText: 'Sexo',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Homem',
                                child: Text('Homem'),
                              ),
                              DropdownMenuItem(
                                value: 'Mulher',
                                child: Text('Mulher'),
                              ),
                            ],
                            onChanged: (v) => setState(() => data.gender = v),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Selecione uma opção';
                              }
                              return null;
                            },
                          ),
                          const Spacer(),

                          // Ações do card (opcional)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // limpa apenas este card
                                  setState(() {
                                    data.nameController.clear();
                                    data.birthDate = null;
                                    data.gender = null;
                                  });
                                },
                                child: const Text('Limpar'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () {
                                  final valid =
                                      _formKeys[index].currentState
                                          ?.validate() ??
                                      false;
                                  if (valid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Card ${index + 1} válido.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.check),
                                label: const Text('Validar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
