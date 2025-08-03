import 'package:flutter/material.dart';

class FormularioCadastro extends StatefulWidget {
  const FormularioCadastro({super.key});

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  DateTime? _dataNascimento;
  String? _sexoSelecionado;

  int calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome Completo"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text("Data de Nascimento:"),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  DateTime? selecionada = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selecionada != null) {
                    setState(() {
                      _dataNascimento = selecionada;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _dataNascimento == null
                        ? "Selecionar data"
                        : "${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                decoration: const InputDecoration(labelText: "Sexo"),
                items: const [
                  DropdownMenuItem(value: 'Homem', child: Text("Homem")),
                  DropdownMenuItem(value: 'Mulher', child: Text("Mulher")),
                ],
                onChanged: (value) {
                  setState(() {
                    _sexoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o sexo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_dataNascimento == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecione a data de nascimento'),
                        ),
                      );
                      return;
                    }

                    final idade = calcularIdade(_dataNascimento!);
                    if (idade < 18) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('É necessário ter mais de 18 anos'),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cadastro realizado com sucesso!'),
                      ),
                    );
                  }
                },
                child: const Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
