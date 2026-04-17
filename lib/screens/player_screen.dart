import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Music Player',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0C29), // Warna ungu super gelap
      ),
      home: const PlayerScreen(),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // State untuk mengontrol jalannya musik dan tombol favorit
  bool isPlaying = false;
  bool isFavorite = false;

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- 1. MEMBUAT PIRINGAN HITAM (VINYL) ---
    Widget vinylRecord = Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Gradasi warna agar terlihat seperti piringan hitam asli
        gradient: const SweepGradient(
          colors: [Color(0xFF222222), Color(0xFF444444), Color(0xFF222222)],
        ),
        border: Border.all(color: Colors.black, width: 8),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: Center(
        // Bagian tengah piringan (Label Album)
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.pinkAccent,
            border: Border.all(color: Colors.white24, width: 4),
          ),
          child: const Icon(Icons.music_note, color: Colors.white, size: 40),
        ),
      ),
    );

    // LOGIKA ANIMASI PIRINGAN HITAM
    // Melayang naik turun setiap saat (tidak peduli sedang diputar atau tidak)
    vinylRecord = vinylRecord.animate(onPlay: (c) => c.repeat(reverse: true))
        // API 1: moveY() - Efek melayang (Hovering) yang mulus
        .moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut);

    // Jika musik sedang diputar (Play), tambahkan animasi berputar!
    if (isPlaying) {
      vinylRecord = vinylRecord.animate(onPlay: (c) => c.repeat())
          // API 2: rotate() - Memutar piringan 360 derajat terus-menerus
          .rotate(duration: 4.seconds, curve: Curves.linear);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            // --- HEADER: NOW PLAYING ---
            Column(
              children: [
                const Text(
                  "NOW PLAYING",
                  style: TextStyle(fontSize: 14, letterSpacing: 4, color: Colors.grey),
                )
                // API 3: animate() - Inisialisasi dasar
                .animate()
                // API 4: fadeIn() - Muncul memudar
                .fadeIn(duration: 800.ms)
                // API 5: shimmer() - Efek kilauan cahaya pada teks
                .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white),

                const SizedBox(height: 10),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: 0, end: 5, duration: 1.seconds),
              ],
            ),

            // --- PIRINGAN HITAM (DIPANGGIL DI SINI) ---
            vinylRecord,

            // --- INFO LAGU & EQUALIZER ---
            Column(
              children: [
                const Text(
                  "Malam Pagi",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                )
                .animate()
                // API 6: slideY() - Masuk dari arah bawah
                .slideY(begin: 0.5, end: 0, duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(),
                
                const SizedBox(height: 5),
                
                const Text(
                  "Saixse",
                  style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                )
                .animate()
                .slideY(begin: 0.5, end: 0, delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(),

                const SizedBox(height: 30),

                // EQUALIZER (BARIS NADA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    // Membuat kotak bar equalizer
                    Widget bar = Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 6,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );

                    // Jika Play: Bar melompat-lompat bergelombang
                    if (isPlaying) {
                      bar = bar.animate(onPlay: (c) => c.repeat(reverse: true))
                          // API 7: scaleY() - Mengubah tinggi (Scale sumbu Y) dari bawah ke atas
                          .scaleY(
                            begin: 0.1, 
                            end: 1.0, 
                            alignment: Alignment.bottomCenter, 
                            duration: 300.ms, 
                            delay: (index * 100).ms // Memberi jeda waktu antar bar agar membentuk gelombang
                          )
                          // API 8: tint() - Mewarnai bar menjadi ungu perlahan-lahan
                          .tint(color: Colors.purpleAccent, end: 0.8);
                    } 
                    // Jika Pause: Bar mengecil dan diam
                    else {
                      bar = bar.animate()
                          .scaleY(begin: 0.1, end: 0.1, alignment: Alignment.bottomCenter, duration: 300.ms);
                    }
                    return bar;
                  }),
                ),
              ],
            ),

            // --- KONTROL PEMUTAR MUSIK ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  // TOMBOL FAVORIT (HATI)
                  IconButton(
                    iconSize: 32,
                    color: Colors.grey, // Warna dasar abu-abu
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: _toggleFavorite,
                  )
                  // API 9: target - Kunci otomatis. Maju jika true, mundur (me-reverse) jika false.
                  .animate(target: isFavorite ? 1 : 0)
                  // API 10: tint() (di-reusable) - Berubah merah saat dilike
                  .tint(color: Colors.redAccent, end: 1.0, duration: 200.ms)
                  // API 11: scale() - Membesar/Popping out
                  .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 200.ms)
                  // API 12: shake() - Berdetak layaknya jantung
                  .shake(hz: 3, curve: Curves.easeInOutCubic),

                  // TOMBOL PREVIOUS
                  const IconButton(
                    iconSize: 45,
                    color: Colors.white,
                    icon: Icon(Icons.skip_previous_rounded),
                    onPressed: null, // Dimatikan untuk contoh UI
                  ),

                  // TOMBOL PLAY / PAUSE BESAR
                  GestureDetector(
                    onTap: _togglePlay,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pinkAccent,
                        boxShadow: [BoxShadow(color: Colors.pinkAccent, blurRadius: 15)]
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, 
                        size: 40, 
                        color: Colors.white
                      ),
                    )
                    // Sedikit membesar saat berubah status
                    .animate(key: ValueKey(isPlaying))
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 200.ms, curve: Curves.easeOutBack),
                  ),

                  // TOMBOL NEXT
                  const IconButton(
                    iconSize: 45,
                    color: Colors.white,
                    icon: Icon(Icons.skip_next_rounded),
                    onPressed: null,
                  ),

                  // TOMBOL SHARE/MORE
                  const IconButton(
                    iconSize: 32,
                    color: Colors.grey,
                    icon: Icon(Icons.share_rounded),
                    onPressed: null,
                  ),
                ]
                // API 13: interval - Membuat seluruh tombol di atas muncul berurutan (staggered) dari kiri ke kanan
                .animate(interval: 200.ms)
                .slideY(begin: 0.5, end: 0, duration: 400.ms)
                .fadeIn(),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}