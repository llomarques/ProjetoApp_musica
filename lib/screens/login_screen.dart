import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'cadastro_screen.dart';
import 'recuperar_senha_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  final _authService = AuthService();

  bool _mostrarSenha = false;
  bool _entrando = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _entrando = true;
    });

    try {
      final resposta = await _authService.entrar(
        email: _usuarioController.text.trim(),
        senha: _senhaController.text,
      );

      if (!mounted) return;

      final usuario = resposta['usuario'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            usuarioId: int.parse(usuario['id'].toString()),
            nomeUsuario: usuario['nome'].toString(),
            username: usuario['username'].toString(),
          ),
        ),
      );

      // Por enquanto, apenas confirma o login.
      // Na próxima etapa vamos navegar para a HomeScreen.
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
          _entrando = false;
        });
      }
    }
  }

  void _abrirCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );
  }

  void _abrirRecuperacao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecuperarSenhaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo / nome do aplicativo
                  const Icon(
                    Icons.music_note_rounded,
                    size: 70,
                    color: Color(0xFF7C4DFF),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'VibeOn',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sua música. Sua vibe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFFB8B8C7)),
                  ),

                  const SizedBox(height: 40),

                  // E-mail
                  TextFormField(
                    controller: _usuarioController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'Digite seu e-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Digite seu e-mail.';
                      }

                      final email = value.trim();

                      final emailValido = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email);

                      if (!emailValido) {
                        return 'Digite um e-mail válido.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite sua senha.';
                      }

                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Esqueci minha senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _abrirRecuperacao,
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Botão Entrar
                  ElevatedButton(
                    onPressed: _entrando ? null : _entrar,
                    child: _entrando
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Ainda não possui uma conta?'),
                      TextButton(
                        onPressed: _abrirCadastro,
                        child: const Text('Cadastre-se'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
