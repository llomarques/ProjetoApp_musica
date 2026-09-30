import 'dart:convert';

import 'package:http/http.dart' as http;

import 'database_config.dart';

class ApiService {
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse(
      '${DatabaseConfig.apiBaseUrl}$path',
    );

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 15));

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Resposta inválida do servidor.');
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          decoded['message']?.toString() ??
              'Erro na comunicação com o servidor.',
        );
      }

      return decoded;
    } catch (e) {
      throw Exception(
        'Não foi possível conectar ao servidor: $e',
      );
    }
  }
}