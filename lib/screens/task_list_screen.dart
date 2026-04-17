import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const NotezQueApp());
}

// --- DATA MODEL TUGAS ---
class Task {
  final String id;
  final String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});
}

class NotezQueApp extends StatelessWidget {
  const NotezQueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotezQue - Daily Tasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Daftar tugas harian (Bisa disesuaikan dengan database MongoDB mas nanti)
  final List<Task> tasks = [
    Task(id: "1", title: "Mengerjakan Tugas PPBL"),
    Task(id: "2", title: "Review Materi Flutter"),
    Task(id: "3", title: "Desain Skema Database NotezQue"),
    Task(id: "4", title: "Meeting Bareng Tim Proyek"),
    Task(id: "5", title: "Push Commit ke GitHub"),
  ];

  // Fungsi untuk mencentang/batal centang tugas
  void _toggleTask(String id) {
    setState(() {
      final taskIndex = tasks.indexWhere((t) => t.id == id);
      if (taskIndex != -1) {
        tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      }
    });
  }

  // Fungsi untuk mengulang animasi dari awal (Reset Semua)
  void _resetTasks() {
    setState(() {
      for (var task in tasks) {
        task.isCompleted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung progress tugas (Misal: 2/5 Selesai)
    int completedCount = tasks.where((t) => t.isCompleted).length;
    double progress = tasks.isEmpty ? 0 : completedCount / tasks.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text("NotezQue Tasks", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // --- HEADER & PROGRESS BAR ---
              const Text(
                "Tugas Hari Ini",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
              )
              // API 1: animate() - Inisialisasi dasar
              .animate()
              // API 2: fadeIn() - Muncul memudar
              .fadeIn(duration: 600.ms)
              // API 3: slideX() - Meluncur dari arah kiri ke kanan
              .slideX(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),

              const SizedBox(height: 10),
              
              Text(
                "$completedCount dari ${tasks.length} selesai",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 20),
              
              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.indigo.shade100,
                color: Colors.indigo,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              )
              // Kunci ini membuat bar ter-animasi ulang tiap nilai progress berubah
              .animate(key: ValueKey(progress))
              // API 4: scaleX() - Membuat bar memanjang secara dinamis
              .scaleX(begin: 0, end: 1, alignment: Alignment.centerLeft, duration: 400.ms, curve: Curves.easeOut),

              const SizedBox(height: 30),

              // --- DAFTAR TUGAS (LIST VIEW) ---
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    
                    // --- WIDGET ITEM TUGAS ---
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        onTap: () => _toggleTask(task.id),
                        
                        // KOTAK CENTANG (CHECKBOX CUSTOM)
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: task.isCompleted ? Colors.green : Colors.grey.shade400, 
                              width: 2
                            ),
                            color: task.isCompleted ? Colors.green : Colors.transparent,
                          ),
                          // Ikon centang hanya muncul kalau isCompleted = true
                          child: task.isCompleted 
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                                // API 5: key() - Memastikan animasi berjalan saat state berubah
                                .animate(key: ValueKey(task.isCompleted))
                                // API 6: scale() - Ikon centang melompat masuk (popping)
                                .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 300.ms, curve: Curves.easeOutBack)
                              : null,
                        ),
                        
                        // TEKS JUDUL TUGAS
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            // Mencoret teks jika tugas selesai
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? Colors.grey : Colors.black87,
                          ),
                        )
                        // Logika Animasi Judul Tugas (Bersinar saat baru dicentang)
                        .animate(target: task.isCompleted ? 1 : 0)
                        // API 7: shimmer() - Kilauan hijau selebrasi saat tugas selesai
                        .shimmer(color: Colors.greenAccent, duration: 600.ms),
                      )
                      
                      // --- LOGIKA ANIMASI CONTAINER TUGAS KESELURUHAN ---
                      // API 8: target - Saklar otomatis yang maju/mundur berdasarkan status selesai
                      .animate(target: task.isCompleted ? 1 : 0)
                      // API 9: moveX() - Tugas bergeser sedikit ke kanan (indentasi)
                      .moveX(end: 15, duration: 300.ms, curve: Curves.easeOut)
                      // API 10: tint() - Warna latar berubah sedikit abu-abu transparan
                      .tint(color: Colors.grey.shade200, end: 0.6)
                      // API 11: blurXY() - Memberikan efek sedikit buram (out of focus) karena sudah selesai
                      .blurXY(end: 0.5, duration: 300.ms),
                    );
                  },
                )
                // --- LOGIKA ANIMASI LIST (STAGGERED) ---
                // Saat aplikasi dibuka, list tidak muncul berbarengan
                .animate()
                // API 12: slideY() - Meluncur dari bawah
                .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut)
                .fadeIn(duration: 400.ms),
              ),
            ],
          ),
        ),
      ),
      
      // TOMBOL RESET
      floatingActionButton: FloatingActionButton(
        onPressed: _resetTasks,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.refresh, color: Colors.white),
      )
      .animate(onPlay: (c) => c.repeat(reverse: true))
      // API 13: moveY() - Efek melayang (hovering) naik turun santai
      .moveY(begin: -5, end: 5, duration: 2.seconds, curve: Curves.easeInOut),
    );
  }
}