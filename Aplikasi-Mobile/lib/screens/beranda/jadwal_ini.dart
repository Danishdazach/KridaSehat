import 'package:flutter/material.dart';

class QuickAccessItem {
  final String title;
  final IconData icon;
  final Color color;

  const QuickAccessItem(this.title, this.icon, this.color);
}

class JadwalHariIniPage extends StatefulWidget {
  final String namaKelas;
  final Map<String, List<String>> jadwalPiket;
  final Map<String, Map<String, dynamic>>? statusPiket;

  const JadwalHariIniPage({
    super.key,
    required this.namaKelas,
    required this.jadwalPiket,
    this.statusPiket,
  });

  @override
  State<JadwalHariIniPage> createState() => _JadwalHariIniPageState();
}

class _JadwalHariIniPageState extends State<JadwalHariIniPage> {
  late Map<String, Map<String, dynamic>> _statusPiket;

  @override
  void initState() {
    super.initState();
    _statusPiket = widget.statusPiket ?? {
      'Senin': {'status': 'selesai', 'catatan': 'Ruang kelas sudah bersih', 'waktu': '07:30'},
      'Selasa': {'status': 'proses', 'catatan': 'Sedang membersihkan papan tulis', 'waktu': '07:15'},
      'Rabu': {'status': 'belum', 'catatan': '', 'waktu': ''},
      'Kamis': {'status': 'belum', 'catatan': '', 'waktu': ''},
      'Jumat': {'status': 'belum', 'catatan': '', 'waktu': ''},
    };
  }

  String _getHariIni() {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[DateTime.now().weekday % 7];
  }

  String _getTanggalHariIni() {
    final now = DateTime.now();
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'proses':
        return Colors.orange;
      case 'terlambat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'selesai':
        return Icons.check_circle;
      case 'proses':
        return Icons.hourglass_empty;
      case 'terlambat':
        return Icons.warning;
      default:
        return Icons.circle_outlined;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'selesai':
        return 'Selesai';
      case 'proses':
        return 'Sedang Proses';
      case 'terlambat':
        return 'Terlambat';
      default:
        return 'Belum Dimulai';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hariIni = _getHariIni();
    final tanggalHariIni = _getTanggalHariIni();
    final petugasHariIni = widget.jadwalPiket[hariIni] ?? [];
    final statusHariIni = _statusPiket[hariIni] ?? {
      'status': 'belum',
      'catatan': '',
      'waktu': ''
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Hari Ini'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            _buildHeaderInfo(hariIni, tanggalHariIni),
            
            // Status Piket Hari Ini
            _buildStatusPiketSection(hariIni, petugasHariIni, statusHariIni),
            
            // Detail Petugas
            _buildDetailPetugasSection(petugasHariIni),
            
            // Tugas Piket
            _buildTugasPiketSection(),
            
            // Aksi Cepat
            _buildAksiCepatSection(hariIni, statusHariIni),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String hari, String tanggal) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hari,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tanggal,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.namaKelas,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPiketSection(String hari, List<String> petugas, Map<String, dynamic> status) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getStatusIcon(status['status']),
                      color: _getStatusColor(status['status']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Piket',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(status['status']),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status['status']),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (status['waktu'].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            status['waktu'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (status['catatan'].isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.note_outlined, size: 16, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          status['catatan'],
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailPetugasSection(List<String> petugas) {
    if (petugas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'Tidak ada jadwal piket hari ini',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Petugas Piket Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...petugas.asMap().entries.map((entry) {
                final index = entry.key;
                final nama = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        radius: 20,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          nama,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.person, color: Colors.grey[400]),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTugasPiketSection() {
    final tugasPiket = [
      'Membersihkan papan tulis',
      'Menyapu lantai kelas',
      'Mengepel lantai',
      'Membersihkan jendela',
      'Merapikan meja dan kursi',
      'Membuang sampah',
      'Menyiram tanaman (jika ada)',
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.checklist, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Daftar Tugas Piket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...tugasPiket.map((tugas) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tugas,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAksiCepatSection(String hari, Map<String, dynamic> status) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAksiButton(
                  'Lapor Selesai',
                  Icons.check_circle,
                  Colors.green,
                  () => _updateStatusPiket('selesai'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAksiButton(
                  'Lapor Proses',
                  Icons.hourglass_empty,
                  Colors.orange,
                  () => _updateStatusPiket('proses'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAksiButton(
                  'Tambah Catatan',
                  Icons.note_add,
                  Colors.blue,
                  () => _showTambahCatatanDialog(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAksiButton(
                  'Lihat Riwayat',
                  Icons.history,
                  Colors.purple,
                  () => _showRiwayatDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAksiButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatusPiket(String newStatus) {
    setState(() {
      _statusPiket[_getHariIni()] = {
        'status': newStatus,
        'waktu': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'catatan': _statusPiket[_getHariIni()]?['catatan'] ?? '',
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status piket berhasil diupdate menjadi "${_getStatusText(newStatus)}"'),
        backgroundColor: _getStatusColor(newStatus),
      ),
    );
  }

  void _showTambahCatatanDialog() {
    final controller = TextEditingController();
    final currentCatatan = _statusPiket[_getHariIni()]?['catatan'] ?? '';
    controller.text = currentCatatan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Catatan'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Masukkan catatan piket...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _statusPiket[_getHariIni()] = {
                  ..._statusPiket[_getHariIni()] ?? {},
                  'catatan': controller.text,
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Catatan berhasil disimpan')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showRiwayatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Riwayat Piket'),
        content: const Text('Fitur riwayat piket akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}