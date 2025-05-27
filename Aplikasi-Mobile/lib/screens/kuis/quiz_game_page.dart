import 'package:flutter/material.dart';
import 'dart:async';

class QuizGamePage extends StatefulWidget {
  final Map<String, dynamic> soal;

  const QuizGamePage({Key? key, required this.soal}) : super(key: key);

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  int currentQuestion = 0;
  int? selectedAnswer;
  int totalScore = 0;
  List<int> answers = [];
  Timer? quizTimer;
  int timeLeft = 0;
  bool quizDone = false;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    setupQuestions();
    startTimer();
  }

  void setupQuestions() {
    // Set soal berdasarkan topik
    if (widget.soal['id'] == 1) {
      questions = getHandWashQuestions();
    } else if (widget.soal['id'] == 2) {
      questions = getFoodQuestions();
    } else if (widget.soal['id'] == 3) {
      questions = getSportQuestions();
    } else if (widget.soal['id'] == 4) {
      questions = getSleepQuestions();
    } else if (widget.soal['id'] == 5) {
      questions = getMentalQuestions();
    } else if (widget.soal['id'] == 6) {
      questions = getHealthyLifeQuestions();
    } else {
      questions = getHandWashQuestions();
    }

    answers = List.filled(questions.length, -1);
    timeLeft = questions.length * 120; // 2 menit per soal
  }

  void startTimer() {
    quizTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          finishQuiz();
        }
      });
    });
  }

  String formatTimer(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void pickAnswer(int index) {
    setState(() {
      selectedAnswer = index;
    });
  }

  void goNext() {
    if (selectedAnswer != null) {
      answers[currentQuestion] = selectedAnswer!;
      
      // Hitung skor
      if (selectedAnswer == questions[currentQuestion]['correct']) {
        totalScore++;
      }

      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
          selectedAnswer = null;
        });
      } else {
        finishQuiz();
      }
    }
  }

  void goBack() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        selectedAnswer = answers[currentQuestion] != -1 
            ? answers[currentQuestion] 
            : null;
      });
    }
  }

  void finishQuiz() {
    quizTimer?.cancel();
    setState(() {
      quizDone = true;
    });
    showResult();
  }

  void showResult() {
    double percent = (totalScore / questions.length) * 100;
    bool pass = percent >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: pass ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                child: Icon(
                  pass ? Icons.check_circle : Icons.cancel,
                  size: 40,
                  color: pass ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text(
                pass ? 'Bagus!' : 'Coba Lagi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: pass ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Skor: ${percent.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'Benar: $totalScore dari ${questions.length}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(
                pass 
                    ? 'Pengetahuan ${widget.soal['judul']} Anda sudah bagus!'
                    : 'Yuk belajar lagi dan coba ulangi kuisnya!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Kembali', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              restartQuiz();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6E7E40),
              foregroundColor: Colors.white,
            ),
            child: Text('Ulangi'),
          ),
        ],
      ),
    );
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      selectedAnswer = null;
      totalScore = 0;
      answers = List.filled(questions.length, -1);
      timeLeft = questions.length * 120;
      quizDone = false;
    });
    startTimer();
  }

  @override
  void dispose() {
    quizTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var currentQ = questions[currentQuestion];
    double progress = (currentQuestion + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.soal['judul']),
        backgroundColor: Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => showExitDialog(),
        ),
      ),
      body: Column(
        children: [
          // Header Progress
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soal ${currentQuestion + 1} dari ${questions.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6E7E40),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: timeLeft < 300 
                            ? Colors.red.withOpacity(0.1) 
                            : Color(0xFF6E7E40).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: timeLeft < 300 ? Colors.red : Color(0xFF6E7E40),
                          ),
                          SizedBox(width: 4),
                          Text(
                            formatTimer(timeLeft),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: timeLeft < 300 ? Colors.red : Color(0xFF6E7E40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6E7E40)),
                  minHeight: 6,
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQ['question'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Answer Options
                  ...List.generate(
                    currentQ['options'].length,
                    (index) => Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: buildAnswerChoice(index, currentQ['options'][index]),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                if (currentQuestion > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: goBack,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF6E7E40)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Kembali',
                        style: TextStyle(
                          color: Color(0xFF6E7E40),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (currentQuestion > 0) SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedAnswer != null ? goNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E7E40),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentQuestion == questions.length - 1 ? 'Selesai' : 'Lanjut',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerChoice(int index, String text) {
    bool picked = selectedAnswer == index;
    
    return GestureDetector(
      onTap: () => pickAnswer(index),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: picked ? Color(0xFF6E7E40) : Colors.grey[300]!,
            width: picked ? 2 : 1,
          ),
          boxShadow: picked ? [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: picked ? Color(0xFF6E7E40) : Colors.grey,
                  width: 2,
                ),
                color: picked ? Color(0xFF6E7E40) : Colors.transparent,
              ),
              child: picked
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: picked ? FontWeight.w600 : FontWeight.normal,
                  color: picked ? Color(0xFF6E7E40) : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Keluar Kuis?'),
        content: Text('Progress akan hilang. Yakin mau keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Soal untuk masing-masing topik
  List<Map<String, dynamic>> getHandWashQuestions() {
    return [
      {
        'question': 'Berapa lama minimal waktu mencuci tangan yang benar?',
        'options': ['10 detik', '20 detik', '30 detik', '1 menit'],
        'correct': 1,
      },
      {
        'question': 'Kapan waktu paling penting untuk mencuci tangan?',
        'options': ['Sebelum makan', 'Setelah ke toilet', 'Setelah batuk', 'Semua benar'],
        'correct': 3,
      },
      {
        'question': 'Apa pengganti sabun jika tidak ada air?',
        'options': ['Tisu basah', 'Hand sanitizer alkohol 60%', 'Air biasa', 'Tidak perlu'],
        'correct': 1,
      },
      {
        'question': 'Langkah pertama mencuci tangan yang benar?',
        'options': ['Gosok telapak', 'Basahi dengan air', 'Tuang sabun', 'Keringkan'],
        'correct': 1,
      },
      {
        'question': 'Bagian yang sering terlupa saat cuci tangan?',
        'options': ['Telapak tangan', 'Punggung tangan', 'Sela jari dan kuku', 'Pergelangan'],
        'correct': 2,
      },
    ];
  }

  List<Map<String, dynamic>> getFoodQuestions() {
    return [
      {
        'question': 'Berapa porsi buah dan sayur per hari?',
        'options': ['3-4 porsi', '5-7 porsi', '8-10 porsi', '1-2 porsi'],
        'correct': 1,
      },
      {
        'question': 'Makanan yang harus dihindari untuk jantung sehat?',
        'options': ['Tinggi serat', 'Tinggi lemak jenuh', 'Tinggi protein', 'Karbohidrat kompleks'],
        'correct': 1,
      },
      {
        'question': 'Apa itu pola makan seimbang?',
        'options': ['Makan 3x sehari', 'Semua kelompok makanan sesuai proporsi', 'Hanya sayuran', 'Hindari semua lemak'],
        'correct': 1,
      },
    ];
  }

  List<Map<String, dynamic>> getSportQuestions() {
    return [
      {
        'question': 'Berapa menit olahraga untuk dewasa per minggu?',
        'options': ['75 menit', '150 menit', '300 menit', '500 menit'],
        'correct': 1,
      },
      {
        'question': 'Contoh olahraga aerobik adalah?',
        'options': ['Angkat beban', 'Yoga', 'Jogging', 'Stretching'],
        'correct': 2,
      },
      {
        'question': 'Manfaat utama olahraga rutin?',
        'options': ['Naik berat badan', 'Kurangi massa otot', 'Sehatkan jantung paru', 'Turunkan metabolisme'],
        'correct': 2,
      },
    ];
  }

  List<Map<String, dynamic>> getSleepQuestions() {
    return [
      {
        'question': 'Berapa jam tidur ideal untuk dewasa?',
        'options': ['5-6 jam', '7-9 jam', '10-12 jam', '4-5 jam'],
        'correct': 1,
      },
      {
        'question': 'Yang harus dihindari sebelum tidur?',
        'options': ['Baca buku', 'Minum kopi', 'Musik santai', 'Mandi hangat'],
        'correct': 1,
      },
      {
        'question': 'Dampak kurang tidur pada kesehatan?',
        'options': ['Naik konsentrasi', 'Turun imun tubuh', 'Tambah energi', 'Perbaiki mood'],
        'correct': 1,
      },
    ];
  }

  List<Map<String, dynamic>> getMentalQuestions() {
    return [
      {
        'question': 'Cara sehat kelola stress?',
        'options': ['Hindari masalah', 'Olahraga dan meditasi', 'Minum alkohol', 'Kerja lebih keras'],
        'correct': 1,
      },
      {
        'question': 'Kesehatan mental yang baik artinya?',
        'options': ['Tidak pernah sedih', 'Bisa atasi stress harian', 'Selalu bahagia', 'Tidak cemas'],
        'correct': 1,
      },
      {
        'question': 'Aktivitas untuk jaga kesehatan mental?',
        'options': ['Isolasi diri', 'Sosialisasi keluarga teman', 'Kerja tanpa istirahat', 'Hindari hobi'],
        'correct': 1,
      },
    ];
  }

  List<Map<String, dynamic>> getHealthyLifeQuestions() {
    return [
      {
        'question': 'Berapa zat kimia berbahaya dalam rokok?',
        'options': ['Lebih dari 70', 'Sekitar 20', 'Kurang dari 10', 'Hanya nikotin'],
        'correct': 0,
      },
      {
        'question': 'Efek jangka panjang merokok?',
        'options': ['Naik stamina', 'Risiko kanker paru', 'Perbaiki napas', 'Kurangi stress'],
        'correct': 1,
      },
      {
        'question': 'Dampak alkohol berlebihan?',
        'options': ['Sehatkan hati', 'Rusak organ hati', 'Naik konsentrasi', 'Perbaiki tidur'],
        'correct': 1,
      },
    ];
  }
}