import 'package:flutter/material.dart';
import 'quiz_game_page.dart';

class KuisPage extends StatelessWidget {
  const KuisPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> daftarSoal = const [
    {
      'id': 1,
      'judul': 'Kebersihan Tangan',
      'deskripsi': 'Pentingnya mencuci tangan untuk mencegah penyakit',
      'icon': Icons.wash,
      'jumlahSoal': 5,
    },
    {
      'id': 2,
      'judul': 'Pola Makan Sehat',
      'deskripsi': 'Gizi seimbang dan kebiasaan makan yang baik',
      'icon': Icons.restaurant,
      'jumlahSoal': 3,
    },
    {
      'id': 3,
      'judul': 'Olahraga Rutin',
      'deskripsi': 'Manfaat aktivitas fisik untuk kesehatan tubuh',
      'icon': Icons.fitness_center,
      'jumlahSoal': 3,
    },
    {
      'id': 4,
      'judul': 'Tidur yang Cukup',
      'deskripsi': 'Pentingnya istirahat yang berkualitas',
      'icon': Icons.bedtime,
      'jumlahSoal': 3,
    },
    {
      'id': 5,
      'judul': 'Kesehatan Mental',
      'deskripsi': 'Menjaga keseimbangan pikiran dan emosi',
      'icon': Icons.psychology,
      'jumlahSoal': 3,
    },
    {
      'id': 6,
      'judul': 'Hindari Rokok & Alkohol',
      'deskripsi': 'Bahaya zat adiktif bagi kesehatan',
      'icon': Icons.smoke_free,
      'jumlahSoal': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
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
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF6E7E40).withOpacity(0.1),
                    child: Icon(
                      Icons.health_and_safety,
                      size: 32,
                      color: Color(0xFF6E7E40),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kuis Tindakan Sehat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E7E40),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tes pengetahuan Anda tentang hidup sehat',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Pilih Topik Kuis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6E7E40),
              ),
            ),

            SizedBox(height: 16),

            // Quiz List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: daftarSoal.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: buildQuizCard(context, daftarSoal[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuizCard(BuildContext context, Map<String, dynamic> soal) {
    return GestureDetector(
      onTap: () => goToInstructions(context, soal),
      child: Container(
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF6E7E40).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    soal['icon'],
                    color: Color(0xFF6E7E40),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        soal['judul'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        soal['deskripsi'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.quiz, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${soal['jumlahSoal']} Soal',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF6E7E40).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Mulai',
                    style: TextStyle(
                      color: Color(0xFF6E7E40),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void goToInstructions(BuildContext context, Map<String, dynamic> soal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstructionsPage(soal: soal),
      ),
    );
  }
}

class InstructionsPage extends StatelessWidget {
  final Map<String, dynamic> soal;

  const InstructionsPage({Key? key, required this.soal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(soal['judul']),
        backgroundColor: Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
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
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFF6E7E40).withOpacity(0.1),
                    child: Icon(
                      soal['icon'],
                      size: 40,
                      color: Color(0xFF6E7E40),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    soal['judul'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E7E40),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    soal['deskripsi'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Info Kuis
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Kuis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E7E40),
                    ),
                  ),
                  SizedBox(height: 16),
                  buildInfoRow(Icons.quiz, 'Jumlah Soal', '${soal['jumlahSoal']} Pertanyaan'),
                  SizedBox(height: 12),
                  buildInfoRow(Icons.timer, 'Waktu', '${soal['jumlahSoal'] * 2} Menit'),
                  SizedBox(height: 12),
                  buildInfoRow(Icons.star, 'Passing Score', '70%'),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Petunjuk
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Petunjuk Kuis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E7E40),
                    ),
                  ),
                  SizedBox(height: 16),
                  buildInstructionText('• Baca setiap pertanyaan dengan teliti'),
                  buildInstructionText('• Pilih jawaban yang paling tepat'),
                  buildInstructionText('• Kuis akan berakhir otomatis saat waktu habis'),
                  buildInstructionText('• Anda dapat mengulang kuis kapan saja'),
                  buildInstructionText('• Skor passing grade adalah 70%'),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => startQuiz(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6E7E40),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Mulai Kuis',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF6E7E40), size: 18),
        SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF6E7E40),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildInstructionText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void startQuiz(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizGamePage(soal: soal),
      ),
    );
  }
}