import 'package:flutter/material.dart';
import '../pokemon.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Teks yang diketik di kotak pencarian
  String kataCari = '';

  // Tipe yang dipilih untuk filter ('semua' = tidak filter)
  String tipeFilter = 'Semua';

  // Ambil semua tipe unik dari daftar Pokemon untuk tombol filter
  List<String> get semuaTipe {
    List<String> tipes = ['Semua'];
    for (var p in daftarPokemon) {
      if (!tipes.contains(p.tipe)) {
        tipes.add(p.tipe);
      }
    }
    tipes.sort();
    tipes.remove('Semua');
    tipes.insert(0, 'Semua'); // 'Semua' tetap di depan
    return tipes;
  }

  // Pokemon yang muncul setelah difilter
  List<Pokemon> get hasilFilter {
    return daftarPokemon.where((p) {
      // Cek apakah nama cocok dengan kata cari
      bool cocokNama = p.nama.toLowerCase().contains(kataCari.toLowerCase());
      // Cek apakah tipe cocok dengan filter
      bool cocokTipe = tipeFilter == 'Semua' || p.tipe == tipeFilter;
      return cocokNama && cocokTipe;
    }).toList();
  }

  // Warna badge tipe Pokemon
  Color warnaTipe(String tipe) {
    switch (tipe) {
      case 'Fire': return Colors.orange;
      case 'Water': return Colors.blue;
      case 'Grass': return Colors.green;
      case 'Electric': return Colors.yellow.shade700;
      case 'Ghost': return Colors.purple;
      case 'Fighting': return Colors.red.shade700;
      case 'Dragon': return Colors.indigo;
      case 'Normal': return Colors.grey;
      case 'Psychic': return Colors.pink;
      case 'Rock': return Colors.brown;
      default: return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasil = hasilFilter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ===== KOTAK PENCARIAN =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (nilai) {
                setState(() {
                  kataCari = nilai;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Pokemon...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // ===== TOMBOL FILTER TIPE =====
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: semuaTipe.map((tipe) {
                bool dipilih = tipeFilter == tipe;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tipeFilter = tipe;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: dipilih ? Colors.red : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tipe,
                      style: TextStyle(
                        color: dipilih ? Colors.white : Colors.black87,
                        fontWeight: dipilih ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${hasil.length} Pokemon ditemukan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ===== GRID POKEMON =====
          Expanded(
            child: hasil.isEmpty
                ? const Center(child: Text('Pokemon tidak ditemukan'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,       // 2 kolom
                      childAspectRatio: 0.8,   // tinggi sedikit lebih besar dari lebar
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: hasil.length,
                    itemBuilder: (context, index) {
                      final pokemon = hasil[index];
                      return _kartuPokemon(pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget kartu Pokemon di grid
  Widget _kartuPokemon(Pokemon pokemon) {
    return GestureDetector(
      onTap: () {
        // Pindah ke halaman detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(pokemon: pokemon),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Gambar Pokemon
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/images/${pokemon.gambar}',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Kalau gambar tidak ada, tampilkan huruf pertama nama
                    return Center(
                      child: Text(
                        pokemon.nama[0],
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Info nama dan tipe
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pokemon.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Badge tipe
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: warnaTipe(pokemon.tipe),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pokemon.tipe,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
