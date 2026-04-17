import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/gestures.dart'; // 1. Tambahkan import ini di paling atas

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Animation',
      // 2. Tambahkan pengaturan scrollBehavior ini agar mouse bisa untuk menggeser
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.trackpad},
      ),
      home: const WeatherScreen(),
    );
  }
}
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PageView memungkinkan kita menggeser layar ke kanan/kiri
      body: PageView(
        controller: _controller,
        children: [
          _buildSunnyPage(context),
          _buildRainyPage(context),
          _buildStormyPage(context),
        ],
      ),
    );
  }

  // ==========================================
  // HALAMAN 1: CUACA CERAH
  // ==========================================
  Widget _buildSunnyPage(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)], // Biru ke Hijau Tosca
        ),
      ),
      child: Stack(
        children: [
          // MATAHARI
          Positioned(
            top: 100,
            right: 40,
            child: const Icon(Icons.wb_sunny, color: Colors.yellow, size: 120)
                // API 1: animate() - Inisialisasi awal
                .animate(onPlay: (c) => c.repeat())
                // API 2: rotate() - Matahari berputar terus-menerus
                .rotate(duration: 10.seconds)
                // API 3: scale() - Membesar (berdenyut)
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds)
                // API 4: then() - Menyambung efek agar setelah membesar, ia mengecil lagi
                .then()
                .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 2.seconds),
          ),
          
          // AWAN BERGERAK
          Positioned(
            top: 150,
            left: 0,
            child: const Icon(Icons.cloud, color: Colors.white, size: 100)
                .animate(onPlay: (c) => c.repeat())
                // API 5: moveX() - Awan berjalan lambat dari luar layar kiri ke luar layar kanan
                .moveX(begin: -150, end: width + 100, duration: 15.seconds),
          ),
          
          // ANTARMUKA TEKS
          _buildWeatherUI("Cerah", "32°C", "Jakarta"),
        ],
      ),
    );
  }

  // ==========================================
  // HALAMAN 2: CUACA HUJAN
  // ==========================================
  Widget _buildRainyPage(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C3E50), Color(0xFF3498DB)], // Biru gelap mendung
        ),
      ),
      child: Stack(
        children: [
          // TITIK-TITIK HUJAN
          for (int i = 0; i < 30; i++)
            Positioned(
              left: (width / 30) * i, // Menyebar hujan di seluruh lebar layar
              top: -50,
              child: Container(width: 2, height: 30, color: Colors.white.withOpacity(0.4))
                  .animate(onPlay: (c) => c.repeat(), delay: (i * 30).ms)
                  // API 6: moveY() - Hujan jatuh dari atas ke bawah
                  .moveY(begin: 0, end: height + 100, duration: 800.ms)
                  // API 7: fade() - Hujan memudar menghilang saat sampai di bawah
                  .fade(begin: 1, end: 0, duration: 800.ms),
            ),
            
          // AWAN MENDUNG MELAYANG
          Positioned(
            top: 50,
            right: 0,
            left: 0,
            child: const Icon(Icons.cloud, color: Colors.white54, size: 200)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                // Awan melayang naik turun dengan pelan
                .moveY(begin: -15, end: 15, duration: 3.seconds, curve: Curves.easeInOut),
          ),
          
          _buildWeatherUI("Hujan Deras", "24°C", "Bogor"),
        ],
      ),
    );
  }

  // ==========================================
  // HALAMAN 3: CUACA BADAI PETIR
  // ==========================================
  Widget _buildStormyPage(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141E30), Color(0xFF243B55)], // Gelap gulita
        ),
      ),
      child: Stack(
        children: [
          // HUJAN BADAI (Lebih banyak & lebih cepat)
          for (int i = 0; i < 40; i++)
            Positioned(
              left: (width / 40) * i,
              top: -50,
              child: Container(width: 3, height: 40, color: Colors.white.withOpacity(0.5))
                  .animate(onPlay: (c) => c.repeat(), delay: (i * 20).ms)
                  .moveY(begin: 0, end: height + 100, duration: 500.ms) // Lebih cepat jatuh
                  .fade(begin: 1, end: 0, duration: 500.ms),
            ),
            
          // KILAT / PETIR
          Positioned(
            top: 80,
            right: 80,
            child: const Icon(Icons.flash_on, color: Colors.yellow, size: 150)
                .animate(onPlay: (c) => c.repeat())
                // API 8: fadeIn() & fadeOut() berturut-turut untuk efek kilat menyambar
                .fadeIn(duration: 50.ms)
                .fadeOut(delay: 150.ms, duration: 200.ms)
                .then(delay: 2.5.seconds), // Jeda 2.5 detik sebelum petir berikutnya
          ),
          
          // AWAN BERGETAR
          Positioned(
            top: 60,
            left: 20,
            child: const Icon(Icons.cloud, color: Colors.grey, size: 180)
                .animate(onPlay: (c) => c.repeat())
                // API 9: shake() - Awan bergetar seolah ada guntur
                .shake(hz: 4, duration: 500.ms)
                .then(delay: 2.seconds),
          ),
          
          _buildWeatherUI("Badai Petir", "22°C", "Bandung"),
        ],
      ),
    );
  }

  // ==========================================
  // ANTARMUKA TEKS (DIPAKAI DI SEMUA HALAMAN)
  // ==========================================
  Widget _buildWeatherUI(String condition, String temp, String city) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            
            // NAMA KOTA
            Text(city, style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold))
                .animate()
                .fadeIn(duration: 800.ms)
                // API 10: slideY() - Teks meluncur dari atas ke bawah
                .slideY(begin: -0.2, end: 0),
            
            const SizedBox(height: 10),
            
            // SUHU (DERAJAT)
            Text(temp, style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.w200))
                .animate()
                .fadeIn(delay: 200.ms)
                // API 11: slideX() - Suhu meluncur dari kiri ke kanan
                .slideX(begin: -0.1, end: 0),
            
            // KONDISI CUACA
            Text(condition, style: const TextStyle(fontSize: 24, color: Colors.white70))
                .animate()
                .fadeIn(delay: 400.ms)
                // API 12: shimmer() - Efek sapuan cahaya berkilau pada teks
                .shimmer(duration: 2.seconds, delay: 1.seconds, color: Colors.white),
            
            const Spacer(),
            
            // PRAKIRAAN JAM-JAMAN
            const Text("Prakiraan Hari Ini", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildForecastItem("08:00", "28°C", Icons.wb_sunny),
                _buildForecastItem("12:00", "32°C", Icons.wb_sunny),
                _buildForecastItem("16:00", "30°C", Icons.cloud),
                _buildForecastItem("20:00", "26°C", Icons.nights_stay),
              ]
              // API 13: interval - Membuat daftar cuaca munculnya berurutan (staggered)
              .animate(interval: 150.ms)
              .slideY(begin: 0.5, end: 0, duration: 400.ms)
              .fadeIn(),
            ),
            
            const SizedBox(height: 30),
            
            // PETUNJUK GESER LAYAR
            Center(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_arrow_left, color: Colors.white54),
                  Text(" Geser ", style: TextStyle(color: Colors.white54)),
                  Icon(Icons.keyboard_arrow_right, color: Colors.white54),
                ],
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveX(begin: -5, end: 5, duration: 1.seconds),
            )
          ],
        ),
      ),
    );
  }

  // WIDGET BANTUAN UNTUK ITEM PRAKIRAAN
  Widget _buildForecastItem(String time, String temp, IconData icon) {
    return Column(
      children: [
        Text(time, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(temp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}