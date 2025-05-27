import 'package:flutter/material.dart';

class DetailJadwalPiketPage extends StatefulWidget {
  final String hari;
  final List<String> petugasPiket;
  final String namaKelas;
  final Map<String, dynamic>? statusPiket;
  final List<Map<String, dynamic>> anggotaKelas;

  const DetailJadwalPiketPage({
    super.key,
    required this.hari,
    required this.petugasPiket,
    required this.namaKelas,
    this.statusPiket,
    required this.anggotaKelas,
  });

  @override
  State<DetailJadwalPiketPage> createState() => _DetailJadwalPiketPageState();
}

class _DetailJadwalPiketPageState extends State<DetailJadwalPiketPage> {
  // Data tugas piket yang lebih detail
  final Map<String, List<String>> tugasPiket = {
    'Membersihkan Papan Tulis': ['Menghapus tulisan', 'Membersihkan spidol/kapur'],
    'Menyapu Lantai': ['Menyapu seluruh ruangan', 'Membersihkan pojok-pojok'],
    'Menata Meja dan Kursi': ['Merapikan posisi meja', 'Menyusun kursi dengan rapi'],
    'Membuang Sampah': ['Mengosongkan tempat sampah', 'Mengganti kantong sampah'],
  };

  // Riwayat kehadiran piket
  List<Map<String, dynamic>> riwayatKehadiran = [
    {
      'tanggal': '20 Mei 2025',
      'hadir': ['Abdul Rahman', 'Siti Nurhaliza'],
      'tidak_hadir': [],
      'terlambat': [],
      'waktu_mulai': '07:00',
      'waktu_selesai': '07:30',
      'nilai': 'A',
      'catatan': 'Semua hadir tepat waktu, kerja sangat baik'
    },
    {
      'tanggal': '13 Mei 2025',
      'hadir': ['Abdul Rahman'],
      'tidak_hadir': ['Siti Nurhaliza'],
      'terlambat': [],
      'waktu_mulai': '07:00',
      'waktu_selesai': '07:45',
      'nilai': 'B',
      'catatan': 'Siti tidak hadir karena sakit'
    },
    {
      'tanggal': '6 Mei 2025',
      'hadir': ['Abdul Rahman', 'Siti Nurhaliza'],
      'tidak_hadir': [],
      'terlambat': ['Siti Nurhaliza'],
      'waktu_mulai': '07:15',
      'waktu_selesai': '07:40',
      'nilai': 'B',
      'catatan': 'Siti terlambat 15 menit'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Piket ${widget.hari}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan informasi dasar
            _buildHeaderInfo(),
            
            // Status piket hari ini (jika ada)
            if (widget.statusPiket != null) _buildStatusHariIni(),
            
            // Daftar petugas piket
            _buildDaftarPetugas(),
            
            // Daftar tugas piket
            _buildDaftarTugas(),
            
            // Riwayat kehadiran
            _buildRiwayatKehadiran(),
            
            // Action buttons
            _buildActionButtons(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    final isToday = _isToday();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.cleaning_services,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Piket ${widget.hari}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.namaKelas,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'HARI INI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${widget.petugasPiket.length} Petugas Piket',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHariIni() {
    if (widget.statusPiket == null) return const SizedBox.shrink();
    
    final status = widget.statusPiket!;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(status['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(status['status']),
                  color: _getStatusColor(status['status']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(status['status']),
                      ),
                    ),
                    Text(
                      _getStatusText(status['status']),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (status['waktu'].isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status['waktu'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (status['catatan'].isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      status['catatan'],
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
    );
  }

  Widget _buildDaftarPetugas() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Petugas Piket',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.petugasPiket.map((nama) {
            // Cari detail siswa dari anggotaKelas
            final siswa = widget.anggotaKelas.firstWhere(
              (s) => s['nama'] == nama,
              orElse: () => {'nama': nama, 'nomor': '00', 'foto': ''},
            );
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: siswa['foto']?.isNotEmpty == true
                          ? ClipOval(
                              child: Image.asset(
                                siswa['foto'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    nama.split(' ').map((n) => n[0]).take(2).join(),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Text(
                              nama.split(' ').map((n) => n[0]).take(2).join(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No. Absen: ${siswa['nomor']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 20,
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

  Widget _buildDaftarTugas() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Tugas Piket',
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
                children: tugasPiket.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                _getTugasIcon(entry.key),
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 38),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: entry.value.map((detail) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        detail,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatKehadiran() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Kehadiran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...riwayatKehadiran.map((riwayat) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          riwayat['tanggal'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getNilaiColor(riwayat['nilai']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Nilai: ${riwayat['nilai']}',
                            style: TextStyle(
                              color: _getNilaiColor(riwayat['nilai']),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Waktu
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          '${riwayat['waktu_mulai']} - ${riwayat['waktu_selesai']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Status kehadiran
                    _buildKehadiranInfo('Hadir', riwayat['hadir'], Colors.green),
                    if (riwayat['terlambat'].isNotEmpty)
                      _buildKehadiranInfo('Terlambat', riwayat['terlambat'], Colors.orange),
                    if (riwayat['tidak_hadir'].isNotEmpty)
                      _buildKehadiranInfo('Tidak Hadir', riwayat['tidak_hadir'], Colors.red),
                    
                    if (riwayat['catatan'].isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.note_outlined, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                riwayat['catatan'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
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
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKehadiranInfo(String label, List<String> names, Color color) {
    if (names.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              names.join(', '),
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isToday = _isToday();
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isToday) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLaporPiketDialog(),
                icon: const Icon(Icons.report),
                label: const Text('Lapor Status Piket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showTukarJadwalDialog(),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Tukar Jadwal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  bool _isToday() {
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
    return daysMap[widget.hari] == today;
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

  IconData _getTugasIcon(String tugas) {
    if (tugas.contains('Papan')) return Icons.border_color;
    if (tugas.contains('Menyapu')) return Icons.cleaning_services;
    if (tugas.contains('Mengepel')) return Icons.water_drop;
    if (tugas.contains('Jendela')) return Icons.window;
    if (tugas.contains('Meja')) return Icons.table_restaurant;
    if (tugas.contains('Sampah')) return Icons.delete;
    if (tugas.contains('Tanaman')) return Icons.local_florist;
    return Icons.task_alt;
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
        ],
      ),
    );
  }

  void _showTukarJadwalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tukar Jadwal Piket'),
        content: const Text('Fitur tukar jadwal akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _updateStatusPiket(String status) {
    // Logic untuk update status piket
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status piket berhasil diupdate: $status'),
        backgroundColor: Colors.green,
      ),
    );
  }
}