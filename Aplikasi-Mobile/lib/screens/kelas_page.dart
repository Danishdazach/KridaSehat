import 'package:flutter/material.dart';
import 'room_page.dart';

class KelasPage extends StatefulWidget {
  final String tingkat;
  final String nama;
  final String email;

  const KelasPage({
    super.key,
    required this.tingkat,
    required this.nama,
    required this.email,
  });

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  final TextEditingController _passwordController = TextEditingController();

  // Mengorganisasi kelas berdasarkan tingkat
  final Map<String, List<String>> _kelasPerTingkat = {
    '7': ['7A', '7B'],
    '8': ['8A', '8B'],
    '9': ['9A', '9B'],
  };

  final Map<String, String> _roomPasswords = {
    '7A': 'pass7a',
    '7B': 'pass7b',
    '8A': 'pass8a',
    '8B': 'pass8b',
    '9A': 'pass9a',
    '9B': 'pass9b',
  };

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _cekPasswordRoom(String? room) {
    if (room == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Masukkan Password untuk $room'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password Room'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_passwordController.text == _roomPasswords[room]) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomPage(
                        nama: widget.nama,
                        email: widget.email,
                        kelas: room,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password salah')),
                  );
                }
                _passwordController.clear();
              },
              child: const Text('Masuk'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> kelasList = _kelasPerTingkat[widget.tingkat] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kelas ${widget.tingkat}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Kelas ${widget.tingkat}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan pilih kelas yang ingin Anda masuki',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: kelasList.length,
                itemBuilder: (context, index) {
                  final kelas = kelasList[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _cekPasswordRoom(kelas),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            kelas,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Klik untuk masuk',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.nama.isEmpty || widget.email.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Card(
                  color: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Perhatian: Identitas Anda belum lengkap! Harap isi nama dan email di halaman Beranda.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}