import 'dart:convert';
import 'dart:io';

import '../lib/database/database_service.dart';

const int serverPort = 5530;

final databaseService = DatabaseService();

Future<void> main() async {
  print('Conectando ao MariaDB...');

  try {
    await databaseService.connect();
  } catch (e) {
    print('Erro ao conectar ao MariaDB: $e');
    return;
  }

  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    serverPort,
  );

  print('=================================');
  print('        VIBEON BACKEND');
  print('=================================');
  print('Servidor rodando na porta $serverPort');
  print('http://127.0.0.1:$serverPort');
  print('=================================');

  await for (final request in server) {
    await _handleRequest(request);
  }
}

Future<void> _handleRequest(HttpRequest request) async {
  final response = request.response;

  response.headers.contentType = ContentType.json;
  response.headers.set('Access-Control-Allow-Origin', '*');
  response.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  response.headers.set(
    'Access-Control-Allow-Headers',
    'Content-Type',
  );

  // Permite requisições OPTIONS.
  if (request.method == 'OPTIONS') {
    response.statusCode = HttpStatus.noContent;
    await response.close();
    return;
  }

  // =========================
  // TESTE DO BACKEND
  // =========================
  if (request.method == 'GET' && request.uri.path == '/health') {
    response.statusCode = HttpStatus.ok;

    response.write(jsonEncode({
      'success': true,
      'message': 'VibeOn Backend funcionando!',
    }));

    await response.close();
    return;
  }

  // =========================
  // CADASTRO
  // =========================
  if (request.method == 'POST' &&
      request.uri.path == '/api/register') {
    await _registerUser(request);
    return;
  }

  if (request.method == 'POST' &&
    request.uri.path == '/api/login') {
  await _loginUser(request);
  return;
}
if (request.method == 'POST' &&
    request.uri.path == '/api/favoritos') {
  await _adicionarFavorito(request);
  return;
}


  // =========================
  // ROTA NÃO ENCONTRADA
  // =========================
  response.statusCode = HttpStatus.notFound;

  response.write(jsonEncode({
    'success': false,
    'message': 'Rota não encontrada',
  }));

  await response.close();
}

Future<void> _registerUser(HttpRequest request) async {
  final response = request.response;

  try {
    // Lê o corpo enviado pelo Flutter.
    final body = await utf8.decoder.bind(request).join();

    if (body.isEmpty) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Dados do cadastro não foram enviados.',
      }));

      await response.close();
      return;
    }

    final data = jsonDecode(body);

    if (data is! Map) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Formato de dados inválido.',
      }));

      await response.close();
      return;
    }

    final nome = data['nome']?.toString().trim() ?? '';
    final email = data['email']?.toString().trim() ?? '';
    final username = data['username']?.toString().trim() ?? '';
    final senha = data['senha']?.toString() ?? '';

    // =========================
    // VALIDAÇÕES
    // =========================

    if (nome.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        senha.isEmpty) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Preencha todos os campos.',
      }));

      await response.close();
      return;
    }

    if (senha.length < 6) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'A senha deve possuir pelo menos 6 caracteres.',
      }));

      await response.close();
      return;
    }

    // =========================
    // VERIFICA EMAIL
    // =========================

    final emailResult = await databaseService.connection.execute(
      'SELECT id FROM usuarios WHERE email = :email LIMIT 1',
      {
        'email': email,
      },
    );

    if (emailResult.rows.isNotEmpty) {
      response.statusCode = HttpStatus.conflict;

      response.write(jsonEncode({
        'success': false,
        'message': 'Este e-mail já está cadastrado.',
      }));

      await response.close();
      return;
    }

    // =========================
    // VERIFICA USERNAME
    // =========================

    final usernameResult = await databaseService.connection.execute(
      'SELECT id FROM usuarios WHERE username = :username LIMIT 1',
      {
        'username': username,
      },
    );

    if (usernameResult.rows.isNotEmpty) {
      response.statusCode = HttpStatus.conflict;

      response.write(jsonEncode({
        'success': false,
        'message': 'Este nome de usuário já está cadastrado.',
      }));

      await response.close();
      return;
    }

    // =========================
    // INSERE USUÁRIO
    // =========================

    await databaseService.connection.execute(
      '''
      INSERT INTO usuarios
      (nome, email, username, senha)
      VALUES
      (:nome, :email, :username, :senha)
      ''',
      {
        'nome': nome,
        'email': email,
        'username': username,
        'senha': senha,
      },
    );

    print('Novo usuário cadastrado: $username');

    response.statusCode = HttpStatus.created;

    response.write(jsonEncode({
      'success': true,
      'message': 'Cadastro realizado com sucesso!',
    }));

    await response.close();
  } catch (e) {
    print('Erro no cadastro: $e');

    response.statusCode = HttpStatus.internalServerError;

    response.write(jsonEncode({
      'success': false,
      'message': 'Erro ao realizar cadastro.',
    }));

    await response.close();
  }
}

Future<void> _loginUser(HttpRequest request) async {
  final response = request.response;

  try {
    final body = await utf8.decoder.bind(request).join();

    if (body.isEmpty) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Informe o e-mail e a senha.',
      }));

      await response.close();
      return;
    }

    final data = jsonDecode(body);

    if (data is! Map) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Dados inválidos.',
      }));

      await response.close();
      return;
    }

    final email = data['email']?.toString().trim() ?? '';
    final senha = data['senha']?.toString() ?? '';

    if (email.isEmpty || senha.isEmpty) {
      response.statusCode = HttpStatus.badRequest;

      response.write(jsonEncode({
        'success': false,
        'message': 'Preencha o e-mail e a senha.',
      }));

      await response.close();
      return;
    }

    final result = await databaseService.connection.execute(
      '''
      SELECT id, nome, email, username
      FROM usuarios
      WHERE email = :email
        AND senha = :senha
      LIMIT 1
      ''',
      {
        'email': email,
        'senha': senha,
      },
    );

    if (result.rows.isEmpty) {
      response.statusCode = HttpStatus.unauthorized;

      response.write(jsonEncode({
        'success': false,
        'message': 'E-mail ou senha incorretos.',
      }));

      await response.close();
      return;
    }

    final usuario = result.rows.first.assoc();

    response.statusCode = HttpStatus.ok;

    response.write(jsonEncode({
      'success': true,
      'message': 'Login realizado com sucesso!',
      'usuario': {
        'id': usuario['id'],
        'nome': usuario['nome'],
        'email': usuario['email'],
        'username': usuario['username'],
      },
    }));

    await response.close();
  } catch (e) {
    print('Erro no login: $e');

    response.statusCode = HttpStatus.internalServerError;

    response.write(jsonEncode({
      'success': false,
      'message': 'Erro ao realizar login.',
    }));

    await response.close();
  }
}

Future<void> _adicionarFavorito(HttpRequest request) async {
  final response = request.response;

  try {
    final body = await utf8.decoder.bind(request).join();

    final dados = jsonDecode(body);

    if (dados is! Map<String, dynamic>) {
      response.statusCode = HttpStatus.badRequest;
      response.write(jsonEncode({
        'success': false,
        'message': 'Dados inválidos.',
      }));
      await response.close();
      return;
    }

    final usuarioId = dados['usuario_id'];
    final musica = dados['musica'];
    final artista = dados['artista'];

    if (usuarioId == null ||
        musica == null ||
        artista == null) {
      response.statusCode = HttpStatus.badRequest;
      response.write(jsonEncode({
        'success': false,
        'message': 'Usuário, música e artista são obrigatórios.',
      }));
      await response.close();
      return;
    }

    await databaseService.connection.execute(
      '''
      INSERT INTO favoritos (
        usuario_id,
        musica,
        artista
      )
      VALUES (
        :usuario_id,
        :musica,
        :artista
      )
      ''',
      {
        'usuario_id': usuarioId,
        'musica': musica,
        'artista': artista,
      },
    );

    response.statusCode = HttpStatus.created;

    response.write(jsonEncode({
      'success': true,
      'message': 'Música adicionada aos favoritos!',
    }));

    await response.close();
  } catch (e) {
    response.statusCode = HttpStatus.internalServerError;

    response.write(jsonEncode({
      'success': false,
      'message': 'Erro ao adicionar favorito: $e',
    }));

    await response.close();
  }
}