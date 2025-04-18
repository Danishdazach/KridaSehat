import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  final String nama;
  final String email;
  final String kelas;

  const RoomPage({
    super.key,
    required this.nama,
    required this.email,
    required this.kelas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Kelas $kelas'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat datang di Room $kelas!',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Nama: $nama', style: const TextStyle(fontSize: 18)),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            Text('Kelas: $kelas', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Aktivitas yang bisa kamu lakukan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Mengisi jadwal piket harian'),
            ),
            const ListTile(
              leading: Icon(Icons.photo_camera, color: Colors.blue),
              title: Text('Upload bukti kebersihan'),
            ),
            const ListTile(
              leading: Icon(Icons.leaderboard, color: Colors.orange),
              title: Text('Lihat peringkat kelas'),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Kembali ke Beranda'),
                onPressed: () {
                  Navigator.pop(context); // kembali ke LandingPage
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
