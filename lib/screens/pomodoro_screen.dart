import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      // Menggunakan tema gelap (Dark Mode) agar warna animasinya lebih menyala
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  // WAKTU UJI COBA: 10 Detik. (Untuk aslinya ubah jadi 25 * 60)
  final int defaultTime = 10; 
  late int timeLeft;
  
  bool isRunning = false;
  bool isFinished = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timeLeft = defaultTime;
  }

  void _toggleTimer() {
    if (isRunning) {
      // Pause
      timer?.cancel();
      setState(() => isRunning = false);
    } else {
      // Play
      setState(() {
        isRunning = true;
        isFinished = false;
      });
      
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            // Waktu Habis!
            timer.cancel();
            isRunning = false;
            isFinished = true;
          }
        });
      });
    }
  }

  void _resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isFinished = false;
      timeLeft = defaultTime;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (timeLeft ~/ 60).toString().padLeft(2, '0');
    String seconds = (timeLeft % 60).toString().padLeft(2, '0');

    const clockStyle = TextStyle(
      fontSize: 80,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Courier', 
    );

    // --- LOGIKA ANIMASI CINCIN ---
    Widget ring = Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isFinished ? Colors.redAccent : Colors.deepPurple, 
          width: 8,
        ),
        boxShadow: [
          if (isRunning)
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 10,
            )
        ],
      ),
    );

    if (isRunning) {
      ring = ring.animate(onPlay: (c) => c.repeat(reverse: true))
          // API 1: fade() - Membuat cincin berkedip
          .fade(begin: 0.5, end: 1, duration: 1.seconds)
          // API 2: scale() - Cincin membesar perlahan (berdetak)
          .scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03), duration: 1.seconds);
    } 
    else if (isFinished) {
      // API 3: repeat() tanpa reverse - Efek peringatan berulang
      ring = ring.animate(onPlay: (c) => c.repeat())
          // API 4: shake() - Getaran keras peringatan waktu habis
          .shake(hz: 6, duration: 600.ms)
          // API 5: shimmer() - Kilatan cahaya merah menyapu cincin
          .shimmer(color: Colors.red, duration: 1.seconds)
          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 500.ms, curve: Curves.easeOutBack)
          // API 6: then() - Menunggu 1.5 detik sebelum cincin bergetar lagi
          .then(delay: 1500.ms); 
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Stack(
                alignment: Alignment.center,
                children: [
                  ring, 
                  // Teks Angka Waktu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(minutes, style: clockStyle)
                          // PERBAIKAN: Tambahkan awalan "min_" agar unik
                          .animate(key: ValueKey("min_$minutes")) 
                          .slideY(begin: -0.2, end: 0, duration: 300.ms)
                          .fadeIn(duration: 300.ms),
                      
                      const Text(":", style: clockStyle),
                      
                      Text(seconds, style: clockStyle)
                          // PERBAIKAN: Tambahkan awalan "sec_" agar unik
                          .animate(key: ValueKey("sec_$seconds")) 
                          .slideY(begin: -0.2, end: 0, duration: 300.ms)
                          .fadeIn(duration: 300.ms),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 50),

              // --- POP-UP WAKTU HABIS (SUDAH DIPERBAIKI, BEBAS FREEZE) ---
              if (isFinished)
                const Text("Waktu Habis! Ayo Istirahat.", 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent)
                )
                .animate()
                // Masuk meluncur memantul dari bawah
                .slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutBack) 
                .fadeIn(duration: 600.ms)
                .then(delay: 500.ms) 
                // API 10: tint() - Menyapu warna putih agar terlihat berkedip menyala
                .tint(color: Colors.white, duration: 500.ms)
                // API 11: moveY() - Melompat kecil ke atas lalu turun lagi
                .moveY(begin: 0, end: -10, duration: 300.ms, curve: Curves.easeOut)
                .then()
                .moveY(begin: -10, end: 0, duration: 300.ms, curve: Curves.bounceOut),

              if (!isFinished)
                const SizedBox(height: 34), 

              const SizedBox(height: 40),

              // --- TOMBOL KONTROL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 60,
                    color: Colors.deepPurpleAccent,
                    icon: Icon(isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    onPressed: _toggleTimer,
                  ),
                  const SizedBox(width: 30),
                  // Animasi menarik perhatian pada tombol reset saat waktu habis
                  IconButton(
                    iconSize: 45,
                    color: isFinished ? Colors.white : Colors.grey,
                    icon: const Icon(Icons.refresh),
                    onPressed: _resetTimer,
                  )
                  // API 12: target - Mengaktifkan rotasi hanya jika isFinished bernilai true
                  .animate(target: isFinished ? 1 : 0)
                  // API 13: rotate() - Memutar tombol reset 360 derajat
                  .rotate(begin: 0, end: 1, duration: 1.seconds, curve: Curves.easeInOut)
                  .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 1.seconds),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}