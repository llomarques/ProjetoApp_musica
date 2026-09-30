
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() =>
      _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState
    extends State<RecuperarSenhaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  bool _enviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _recuperarSenha() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _enviado = true;
    });

    
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail';
    }

    final email = value.trim();

    final emailValido = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);

    if (!emailValido) {
      return 'Informe um e-mail válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                const Icon(
                  Icons.lock_reset_rounded,
                  size: 90,
                  color: AppTheme.primary,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Informe seu e-mail e enviaremos as '
                  'instruções para recuperar sua conta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'seuemail@email.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),
                  validator: _validarEmail,
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _recuperarSenha,
                  child: const Text(
                    'Recuperar senha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (_enviado)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.greenAccent,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Solicitação realizada com sucesso! '
                            'Verifique seu e-mail.',
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Voltar para o Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

