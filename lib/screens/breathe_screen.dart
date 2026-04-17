import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MeditationApp());
}

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Meditasi',
      theme: ThemeData.dark(),
      home: const BreatheScreen(),
    );
  }
}

class BreatheScreen extends StatelessWidget {
  const BreatheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dipindah ke dalam build tanpa const agar lebih aman
    final textStyle = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      color: Colors.white,
      letterSpacing: 2,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          
          // --- 1. LATAR BELAKANG ---
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blue.shade900, Colors.black],
                radius: 1.5,
              ),
            ),
          )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .tint(color: Colors.purple.shade900, duration: 4.seconds) 
          .blurXY(begin: 0, end: 10, duration: 4.seconds), 

          // --- 2. LINGKARAN PERNAPASAN ---
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.tealAccent.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(color: Colors.teal.withOpacity(0.5), blurRadius: 30, spreadRadius: 10)
                ]
              ),
            )
            // Membesar 4 detik, mengecil 4 detik (Total 8 detik)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(begin: const Offset(1, 1), end: const Offset(2.5, 2.5), duration: 4.seconds, curve: Curves.easeInOutSine),
          ),

// --- 3. TEKS PANDUAN (DIJAMIN 100% ANTI TABRAKAN & TIDAK HILANG) ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  
                  // TEKS 1: Tarik Napas
                  Text("Tarik Napas...", style: textStyle)
                      .animate(onPlay: (c) => c.repeat())
                      .fadeIn(duration: 1.seconds)
                      .slideY(begin: 0.2, end: 0, duration: 1.seconds, curve: Curves.easeOut)
                      .shimmer(delay: 1.seconds, duration: 2.seconds, color: Colors.white54)
                      .fadeOut(delay: 3.seconds, duration: 1.seconds)
                      // TRIK RAHASIA: Tambahkan pergerakan 0 milidetik di detik ke-8
                      // Ini memaksa siklus Tarik Napas menjadi genap 8 detik!
                      .move(delay: 8.seconds, duration: 0.ms),

                  // TEKS 2: Buang Napas
                  Text("Buang Napas...", style: textStyle)
                      .animate(onPlay: (c) => c.repeat())
                      // Otomatis tersembunyi selama 4 detik pertama berkat delay
                      .fadeIn(delay: 4.seconds, duration: 1.seconds)
                      .slideY(begin: -0.2, end: 0, delay: 4.seconds, duration: 1.seconds, curve: Curves.easeOut)
                      .shimmer(delay: 5.seconds, duration: 2.seconds, color: Colors.white54)
                      .fadeOut(delay: 7.seconds, duration: 1.seconds),
                      
                ],
              ),
              const SizedBox(height: 250),
            ],
          ),          
        ],
      ),
    );
  }
}