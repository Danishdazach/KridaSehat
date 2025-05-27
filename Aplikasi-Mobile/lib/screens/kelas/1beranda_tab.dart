import 'package:flutter/material.dart';
import 'detail_jadwal_piket_page.dart';

class BerandaTab extends StatefulWidget {
  final String namaKelas;
  final String waliKelas;
  final List<Map<String, dynamic>> anggotaKelas;
  final Map<String, List<String>> jadwalPiket;

  const BerandaTab({
    super.key,
    required this.namaKelas,
    required this.waliKelas,
    required this.anggotaKelas,
    required this.jadwalPiket,
  });

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {
  // Data status piket (simulasi - dalam aplikasi nyata akan dari database)
  Map<String, Map<String, dynamic>> statusPiket = {
    'Senin': {'status': 'selesai', 'catatan': 'Ruang kelas sudah bersih', 'waktu': '07:30'},
    'Selasa': {'status': 'proses', 'catatan': 'Sedang membersihkan papan tulis', 'waktu': '07:15'},
    'Rabu': {'status': 'belum', 'catatan': '', 'waktu': ''},
    'Kamis': {'status': 'belum', 'catatan': '', 'waktu': ''},
    'Jumat': {'status': 'belum', 'catatan': '', 'waktu': ''},
  };

  // Riwayat piket mingguan
  List<Map<String, dynamic>> riwayatPiket = [
    {
      'hari': 'Senin',
      'tanggal': '20 Mei 2025',
      'petugas': ['Abdul Rahman', 'Siti Nurhaliza'],
      'status': 'selesai',
      'nilai': 'A',
      'catatan': 'Sangat baik, ruang kelas bersih sempurna'
    },
    {
      'hari': 'Selasa',
      'tanggal': '21 Mei 2025',
      'petugas': ['Budi Santoso', 'Dewi Lestari'],
      'status': 'selesai',
      'nilai': 'A',
      'catatan': 'Baik, tapi perlu lebih teliti di area jendela'
    },
    {
      'hari': 'Rabu',
      'tanggal': '22 Mei 2025',
      'petugas': ['Eko Prasetyo', 'Fitriani'],
      'status': 'terlambat',
      'nilai': 'B',
      'catatan': 'Terlambat 15 menit, tapi hasil bersih baik'
    },
    {
      'hari': 'Kamis',
      'tanggal': '16 Mei 2025',
      'petugas': ['Galih Pratama', 'Hana Sari'],
      'status': 'selesai',
      'nilai': 'A',
      'catatan': 'Excellent work, semua area bersih'
    },
    {
      'hari': 'Jumat',
      'tanggal': '17 Mei 2025',
      'petugas': ['Irfan Hakim', 'Jihan Aulia'],
      'status': 'selesai',
      'nilai': 'B',
      'catatan': 'Cukup baik, tapi masih ada sampah di pojok'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          _buildHeroSection(),
          
          const SizedBox(height: 60),
          
          // Quick Action Buttons untuk Piket
          _buildQuickActions(),
          
          // Status Piket Hari Ini
          _buildStatusPiketHariIni(),
          
          // Jadwal Piket Minggu Ini
          _buildJadwalPiket(),
          
          // Riwayat Piket
          _buildRiwayatPiket(),
          
          // History Laporan
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withAlpha(179),
              ],
            ),
          ),
          child: Image.asset(
            'assets/foto_kelas_utama.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withAlpha(77),
            colorBlendMode: BlendMode.darken,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image, size: 80, color: Colors.white54);
            },
          ),
        ),
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.namaKelas,
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.anggotaKelas.length} Siswa',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Wali Kelas: ${widget.waliKelas}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                child: _buildQuickActionCard(
                  'Lapor Piket',
                  'Laporkan status piket hari ini',
                  Icons.check_circle_outline,
                  Colors.green,
                  () => _showLaporPiketDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPiketHariIni() {
    String hariIni = _getHariIni();
    Map<String, dynamic>? statusHariIni = statusPiket[hariIni];
    List<String>? petugasHariIni = widget.jadwalPiket[hariIni];

    if (statusHariIni == null || petugasHariIni == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Piket Hari Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(statusHariIni['status']).withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getStatusIcon(statusHariIni['status']),
                          color: _getStatusColor(statusHariIni['status']),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$hariIni - ${_getStatusText(statusHariIni['status'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Petugas: ${petugasHariIni.join(', ')}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (statusHariIni['waktu'].isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusHariIni['waktu'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (statusHariIni['catatan'].isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              statusHariIni['catatan'],
                              style: TextStyle(
                                color: Colors.grey[700],
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
        ],
      ),
    );
  }

  Widget _buildJadwalPiket() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jadwal Piket Minggu Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.jadwalPiket.entries.map((entry) {
                  final isToday = _isDayToday(entry.key);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: isToday
                          ? Border(
                              left: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 4,
                              ),
                            )
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isToday
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          entry.key.substring(0, 1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        entry.value.join(', '),
                        style: TextStyle(
                          color: isToday ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                      trailing: isToday
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Hari Ini',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailJadwalPiketPage(
                              hari: entry.key,
                              petugasPiket: entry.value,
                              namaKelas: widget.namaKelas,
                              anggotaKelas: widget.anggotaKelas,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildRiwayatPiket() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Piket',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...riwayatPiket.take(3).map((riwayat) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getNilaiColor(riwayat['nilai']).withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        riwayat['nilai'],
                        style: TextStyle(
                          color: _getNilaiColor(riwayat['nilai']),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${riwayat['hari']} - ${riwayat['tanggal']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            riwayat['petugas'].join(', '),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          if (riwayat['catatan'].isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              riwayat['catatan'],
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(riwayat['status']).withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        riwayat['status'],
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(riwayat['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Helper methods
  String _getHariIni() {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[DateTime.now().weekday % 7];
  }

  bool _isDayToday(String day) {
    final daysMap = {
      'Senin': DateTime.monday,
      'Selasa': DateTime.tuesday,
      'Rabu': DateTime.wednesday,
      'Kamis': DateTime.thursday,
      'Jumat': DateTime.friday,
      'Sabtu': DateTime.saturday,
      'Minggu': DateTime.sunday,
    };
    
    final today = DateTime.now().weekday;
    return daysMap[day] == today;
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
        return 'Proses';
      case 'terlambat':
        return 'Terlambat';
      default:
        return 'Belum';
    }
  }

  Color _getNilaiColor(String nilai) {
    switch (nilai) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Dialog methods
  void _showLaporPiketDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lapor Status Piket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih status piket hari ini:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Selesai'),
              onTap: () {
                Navigator.pop(context);
                _updateStatusPiket('selesai');
              },
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_empty, color: Colors.orange),
              title: const Text('Sedang Proses'),
              onTap: () {
                Navigator.pop(context);
                _updateStatusPiket('proses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('Terlambat'),
              onTap: () {
                Navigator.pop(context);
                _updateStatusPiket('terlambat');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatusPiket('belum');
            },
            child: const Text('Belum'),
          ),
        ],
      ),
    );
  }
  
  void _updateStatusPiket(String status) {
    setState(() {
      statusPiket[_getHariIni()] = {'status': status, 'waktu': '08:00', 'catatan': ''};
    });
  }
}