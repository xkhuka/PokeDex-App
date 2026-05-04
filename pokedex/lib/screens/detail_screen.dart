import 'package:flutter/material.dart';
import '../pokemon.dart';

class DetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const DetailScreen({super.key, required this.pokemon});

  Color warnaTipe(String tipe) {
    switch (tipe) {
      case 'Fire':     return Colors.orange;
      case 'Water':    return Colors.blue;
      case 'Grass':    return Colors.green;
      case 'Electric': return Colors.yellow.shade700;
      case 'Ghost':    return Colors.purple;
      case 'Fighting': return Colors.red.shade700;
      case 'Dragon':   return Colors.indigo;
      case 'Normal':   return Colors.grey;
      case 'Psychic':  return Colors.pink;
      case 'Rock':     return Colors.brown;
      case 'Ice':      return Colors.cyan;
      case 'Dark':     return Colors.brown.shade800;
      case 'Steel':    return Colors.blueGrey;
      case 'Fairy':    return Colors.pinkAccent;
      case 'Bug':      return Colors.lightGreen.shade700;
      case 'Ground':   return Colors.orange.shade800;
      case 'Flying':   return Colors.lightBlue;
      default:         return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color warnaUtama = warnaTipe(pokemon.tipe);

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nama),
        backgroundColor: warnaUtama,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== GAMBAR =====
            Container(
              width: double.infinity,
              height: 240,
              color: warnaUtama.withAlpha(40),
              padding: const EdgeInsets.all(24),
              child: Image.asset(
                'assets/images/${pokemon.gambar}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      pokemon.nama[0],
                      style: TextStyle(fontSize: 80, color: warnaUtama.withAlpha(120)),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== NAMA + TIPE =====
                  Row(
                    children: [
                      Text(
                        pokemon.nama,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: warnaUtama,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pokemon.tipe,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ===== DESKRIPSI =====
                  _judulSeksi('Deskripsi'),
                  const SizedBox(height: 6),
                  Text(
                    pokemon.deskripsi,
                    style: const TextStyle(fontSize: 14, height: 1.7, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // ===== KEMAMPUAN =====
                  _judulSeksi('Kemampuan (Ability)'),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: warnaUtama.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: warnaUtama.withAlpha(80)),
                    ),
                    child: Text(
                      pokemon.kemampuan,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== EVOLUSI =====
                  _judulSeksi('Evolusi'),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      pokemon.evolusi,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== KELEMAHAN =====
                  _judulSeksi('Kelemahan'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pokemon.kelemahan.map((k) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: warnaTipe(k),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          k,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // ===== BASE STATS =====
                  _judulSeksi('Base Stats'),
                  const SizedBox(height: 10),
                  _statBar('HP',      pokemon.hp,      Colors.green,  160),
                  _statBar('Attack',  pokemon.attack,  Colors.red,    160),
                  _statBar('Defense', pokemon.defense, Colors.blue,   160),
                  _statBar('Speed',   pokemon.speed,   Colors.orange, 160),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget judul seksi
  Widget _judulSeksi(String teks) {
    return Text(
      teks,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // Widget bar stat
  Widget _statBar(String label, int nilai, Color warna, int maks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: nilai / maks,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(warna),
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$nilai',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
