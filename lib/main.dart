import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const QuizApp());
}

// --- DATA MODEL UNTUK SOAL ---
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question(this.text, this.options, this.correctIndex);
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kuis Interaktif',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto',
      ),
      home: const QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Daftar Soal
  final List<Question> questions = [
    Question(
      "Framework apa yang sedang kita gunakan sekarang?",
      ["React Native", "Flutter", "Ionic", "Xamarin"],
      1, // Flutter
    ),
    Question(
      "Bahasa pemrograman utama untuk Flutter adalah?",
      ["Java", "Kotlin", "Dart", "Swift"],
      2, // Dart
    ),
    Question(
      "Widget yang ukurannya tidak bisa berubah setelah dirender disebut?",
      ["StatefulWidget", "StatelessWidget", "Container", "Scaffold"],
      1, // StatelessWidget
    ),
  ];

  int currentIndex = 0;
  int? selectedAnswerIndex;
  bool isAnswered = false;

  void _submitAnswer(int index) {
    if (isAnswered) return; 
    setState(() {
      selectedAnswerIndex = index;
      isAnswered = true;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        isAnswered = false;
        selectedAnswerIndex = null;
      } else {
        currentIndex = 0;
        isAnswered = false;
        selectedAnswerIndex = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentIndex];
    final bool isCorrectAnswer = selectedAnswerIndex == currentQ.correctIndex;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Kuis Pemrograman", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
// --- BAGIAN KARTU SOAL (FINAL & KONSISTEN) ---
              Container(
                key: ValueKey<int>(currentIndex), 
                height: 260, // KUNCI UTAMA: Kunci tinggi kartu di 260px agar tidak menciut saat dibalik
                child: Stack(
                  children: [
                    
                    // 1. KARTU BELAKANG (Hasil Benar/Salah)
                    Positioned.fill( // KEMBALIKAN Positioned.fill agar mengisi penuh kotak 260px
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isCorrectAnswer ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCorrectAnswer ? Colors.green : Colors.red,
                            width: 3,
                          ),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                              color: isCorrectAnswer ? Colors.green : Colors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              isCorrectAnswer ? "Jawaban Anda Benar!" : "Jawaban Anda Salah!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22, 
                                fontWeight: FontWeight.bold,
                                color: isCorrectAnswer ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ],
                        ),
                      )
                      // Logika Animasi Kartu Belakang
                      .animate(target: isAnswered ? 1 : 0)
                      .fadeIn(delay: 300.ms, duration: 10.ms) 
                      .flipH(begin: -0.25, end: 0, duration: 300.ms, delay: 300.ms, curve: Curves.easeOut), 
                    ),

                    // 2. KARTU DEPAN (Pertanyaan)
                    Positioned.fill( // KEMBALIKAN Positioned.fill agar mengisi penuh kotak 260px
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pertanyaan ${currentIndex + 1}/${questions.length}",
                              style: TextStyle(color: Colors.deepPurple[300], fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              currentQ.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                      // Logika Animasi Kartu Depan
                      .animate(target: isAnswered ? 1 : 0)
                      .flipH(begin: 0, end: 0.25, duration: 300.ms, curve: Curves.easeIn)
                      .then() 
                      .fadeOut(duration: 10.ms), 
                    ),

                  ],
                ),
              )
              // Animasi saat soal baru muncul
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.2, end: 0, curve: Curves.easeOut),

              const SizedBox(height: 40),

              // --- DAFTAR JAWABAN (TETAP SAMA) ---
              Column(
                key: ValueKey<int>(currentIndex + 100),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(currentQ.options.length, (index) {
                  bool isSelected = selectedAnswerIndex == index;
                  bool isCorrectBtn = index == currentQ.correctIndex;

                  Widget button = ElevatedButton(
                    onPressed: isAnswered ? null : () => _submitAnswer(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      currentQ.options[index],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  );

                  if (isAnswered) {
                    if (isSelected && !isCorrectBtn) {
                      button = button.animate()
                        .shake(hz: 4, duration: 400.ms)
                        .tint(color: Colors.red, end: 0.6);
                    } else if (isCorrectBtn) {
                      button = button.animate(delay: 200.ms)
                        .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 300.ms)
                        .shimmer(color: Colors.amber, duration: 1.seconds)
                        .tint(color: Colors.green, end: 0.4);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: button,
                  );
                })
                .animate(interval: 150.ms)
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.2, end: 0, curve: Curves.easeOut),
              ),

              const Spacer(),

              // --- TOMBOL LANJUTKAN (TETAP SAMA) ---
              if (isAnswered)
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    currentIndex == questions.length - 1 ? "Ulangi Kuis" : "Soal Selanjutnya",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                .animate()
                .slideY(begin: 1, end: 0, curve: Curves.easeOutBack)
                .fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}