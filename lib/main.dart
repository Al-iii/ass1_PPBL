import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// --- IMPORT SEMUA HALAMAN DI SINI ---
// Pastikan nama file-nya sesuai dengan yang mas buat di folder screens
import 'screens/quiz_screen.dart';
import 'screens/breathe_screen.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/player_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const PPBLPortfolioApp());
}

class PPBLPortfolioApp extends StatelessWidget {
  const PPBLPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portofolio PPBL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DAFTAR MENU APLIKASI ---
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Kuis Interaktif',
        'icon': Icons.lightbulb_outline,
        'color': Colors.orangeAccent,
        'page': const QuizScreen()
      },
      {
        'title': 'Meditasi',
        'icon': Icons.self_improvement,
        'color': Colors.teal,
        'page': const BreatheScreen()
      },
      {
        'title': 'Jam Fokus',
        'icon': Icons.timer_outlined,
        'color': Colors.redAccent,
        'page': const PomodoroScreen()
      },
      {
        'title': 'Pemutar Musik',
        'icon': Icons.music_note_rounded,
        'color': Colors.pinkAccent,
        'page': const PlayerScreen()
      },
      {
        'title': 'Cuaca Dinamis',
        'icon': Icons.cloud_outlined,
        'color': Colors.lightBlue,
        'page': const WeatherScreen()
      },
      {
        'title': 'NotezQue To-Do',
        'icon': Icons.check_box_outlined,
        'color': Colors.indigo,
        'page': const TaskListScreen()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kumpulan Animasi PPBL", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const Text(
                "Pilih Proyek",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),

              const SizedBox(height: 5),
              
              const Text(
                "Demonstrasi penggunaan flutter_animate",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),

              const SizedBox(height: 30),

// --- GRID MENU (SUDAH DIPERBAIKI) ---
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom menyamping
                    crossAxisSpacing: 15, // Jarak antar kolom
                    mainAxisSpacing: 15, // Jarak antar baris
                    childAspectRatio: 1.1, // Proporsi kotak
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => item['page']),
                          );
                        },
                        splashColor: item['color'].withOpacity(0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                item['color'].withOpacity(0.1), 
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: item['color'].withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(item['icon'], size: 40, color: item['color']),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    // PERBAIKAN: Animasi dipasang di masing-masing Card
                    .animate()
                    // Menggunakan perhitungan delay (index * 100) agar muncul bergantian
                    .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutBack, delay: (index * 100).ms)
                    .fadeIn(duration: 500.ms, delay: (index * 100).ms);
                  },
                ),
              ),             
            ],
          ),
        ),
      ),
    );
  }
}