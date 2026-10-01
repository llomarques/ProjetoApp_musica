import 'api_service.dart';

class FavoritoService {
  final ApiService _api;

  FavoritoService({ApiService? api})
      : _api = api ?? ApiService();

  Future<String> adicionarFavorito({
    required int usuarioId,
    required String musica,
    required String artista,
  }) async {
    final response = await _api.post(
      '/api/favoritos',
      {
        'usuario_id': usuarioId,
        'musica': musica,
        'artista': artista,
      },
    );

    return response['message']?.toString() ??
        'Música adicionada aos favoritos!';
  }
}