import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService({ApiService? api})
      : _api = api ?? ApiService();

  Future<String> cadastrar({
    required String nome,
    required String email,
    required String username,
    required String senha,
  }) async {
    final response = await _api.post(
      '/api/register',
      {
        'nome': nome,
        'email': email,
        'username': username,
        'senha': senha,
      },
    );

    return response['message']?.toString() ??
        'Cadastro realizado com sucesso!';
  }

  Future<Map<String, dynamic>> entrar({
    required String email,
    required String senha,
  }) async {
    final response = await _api.post(
      '/api/login',
      {
        'email': email,
        'senha': senha,
      },
    );

    return response;
  }
}