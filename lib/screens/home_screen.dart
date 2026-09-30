import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String nomeUsuario;
  final String username;

  const HomeScreen({
    super.key,
    required this.nomeUsuario,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeOn'),
        actions: [
          IconButton(
            onPressed: () {},
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
              'Olá, $nomeUsuario! ',
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
              children: [
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

            const _MusicaCard(
              titulo: 'Vibe do Dia',
              artista: 'VibeOn',
              icon: Icons.music_note,
            ),

            const _MusicaCard(
              titulo: 'Noite Tranquila',
              artista: 'VibeOn',
              icon: Icons.nightlight,
            ),

            const _MusicaCard(
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
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

// --------------------------------------------------
// CARD DA MÚSICA
// --------------------------------------------------

class _MusicaCard extends StatefulWidget {
  final String titulo;
  final String artista;
  final IconData icon;

  const _MusicaCard({
    required this.titulo,
    required this.artista,
    required this.icon,
  });

  @override
  State<_MusicaCard> createState() => _MusicaCardState();
}

class _MusicaCardState extends State<_MusicaCard> {
  bool _favoritada = false;

  void _alternarFavorito() {
    setState(() {
      _favoritada = !_favoritada;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _favoritada
              ? '${widget.titulo} adicionada aos favoritos! 💜 '
              : '${widget.titulo} removida dos favoritos.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
          onPressed: _alternarFavorito,
          icon: Icon(
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