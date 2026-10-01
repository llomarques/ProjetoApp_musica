
import 'package:flutter/material.dart';
import '../services/favorito_service.dart';

class HomeScreen extends StatefulWidget {
  final int usuarioId;
  final String nomeUsuario;
  final String username;

  const HomeScreen({
    super.key,
    required this.usuarioId,
    required this.nomeUsuario,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _favoritoService = FavoritoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeOn'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil em construção!'),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${widget.nomeUsuario}! 👋',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Qual é a sua vibe hoje?',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFB8B8C7),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Escolha uma vibe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _VibeButton(
                  icon: Icons.sentiment_satisfied_alt,
                  label: 'Feliz',
                ),
                _VibeButton(
                  icon: Icons.nightlight_round,
                  label: 'Relax',
                ),
                _VibeButton(
                  icon: Icons.favorite,
                  label: 'Romântica',
                ),
                _VibeButton(
                  icon: Icons.bolt,
                  label: 'Energia',
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Músicas recomendadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _MusicaCard(
              usuarioId: widget.usuarioId,
              favoritoService: _favoritoService,
              titulo: 'Vibe do Dia',
              artista: 'VibeOn',
              icon: Icons.music_note,
            ),

            _MusicaCard(
              usuarioId: widget.usuarioId,
              favoritoService: _favoritoService,
              titulo: 'Noite Tranquila',
              artista: 'VibeOn',
              icon: Icons.nightlight,
            ),

            _MusicaCard(
              usuarioId: widget.usuarioId,
              favoritoService: _favoritoService,
              titulo: 'Energia Total',
              artista: 'VibeOn',
              icon: Icons.bolt,
            ),
          ],
        ),
      ),
    );
  }
}

// BOTÕES DE VIBE

class _VibeButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _VibeButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vibe selecionada: $label'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

// CARD DE MÚSICA COM FAVORITOS

class _MusicaCard extends StatefulWidget {
  final int usuarioId;
  final FavoritoService favoritoService;
  final String titulo;
  final String artista;
  final IconData icon;

  const _MusicaCard({
    required this.usuarioId,
    required this.favoritoService,
    required this.titulo,
    required this.artista,
    required this.icon,
  });

  @override
  State<_MusicaCard> createState() => _MusicaCardState();
}

class _MusicaCardState extends State<_MusicaCard> {
  bool _favoritada = false;
  bool _salvando = false;

  Future<void> _alternarFavorito() async {
    if (_favoritada || _salvando) return;

    setState(() {
      _salvando = true;
    });

    try {
      final mensagem =
          await widget.favoritoService.adicionarFavorito(
        usuarioId: widget.usuarioId,
        musica: widget.titulo,
        artista: widget.artista,
      );

      if (!mounted) return;

      setState(() {
        _favoritada = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _salvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A1A2E),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF7C4DFF),
          child: Icon(
            widget.icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(widget.artista),
        trailing: IconButton(
          onPressed: _salvando ? null : _alternarFavorito,
          icon: _salvando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  _favoritada
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
          color: _favoritada
              ? const Color(0xFFE040FB)
              : null,
          tooltip: _favoritada
              ? 'Remover dos favoritos'
              : 'Adicionar aos favoritos',
        ),
      ),
    );
  }
}