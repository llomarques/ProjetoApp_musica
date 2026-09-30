import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final _authService = AuthService();

  bool _mostrarSenha = false;
  bool _mostrarConfirmacao = false;
  bool _enviando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _usuarioController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();

    super.dispose();
  }

  Future<void> _cadastrar() async {
    {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _enviando = true;
      });

      try {
        final mensagem = await _authService.cadastrar(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          username: _usuarioController.text.trim(),
          senha: _senhaController.text,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem), backgroundColor: Colors.green),
        );

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _enviando = false;
          });
        }
      }
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail';
    }

    final email = value.trim();

    final emailValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!emailValido) {
      return 'Informe um e-mail válido';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
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
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 70,
                  color: AppTheme.primary,
                ),

                const SizedBox(height: 16),

                const Text(
                  'Crie sua conta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Entre para descobrir sua nova vibe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome';
                    }

                    if (value.trim().length < 2) {
                      return 'Informe um nome válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _validarEmail,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(
                    labelText: 'Nome de usuário',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe um nome de usuário';
                    }

                    if (value.trim().length < 3) {
                      return 'O usuário deve ter pelo menos 3 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarSenha = !_mostrarSenha;
                        });
                      },
                      icon: Icon(
                        _mostrarSenha ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha';
                    }

                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: !_mostrarConfirmacao,
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarConfirmacao = !_mostrarConfirmacao;
                        });
                      },
                      icon: Icon(
                        _mostrarConfirmacao
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    }

                    if (value != _senhaController.text) {
                      return 'As senhas não são iguais';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 28),

                ElevatedButton(
                  onPressed: _enviando ? null : _cadastrar,
                  child: _enviando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Cadastrar'),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Já tenho uma conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
