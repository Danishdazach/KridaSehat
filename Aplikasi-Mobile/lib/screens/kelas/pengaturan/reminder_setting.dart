import 'package:flutter/material.dart';

class ReminderSettingsPage extends StatefulWidget {
  final String className;
  final String waliKelas;
  final List<Map<String, dynamic>> anggotaKelas;
  final Map<String, List<String>> jadwalPiket;

  const ReminderSettingsPage({
    super.key,
    required this.className,
    required this.waliKelas,
    required this.anggotaKelas,
    required this.jadwalPiket,
  });

  @override
  State<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

  // Pengaturan pengingat
  Map<String, bool> reminderSettings = {
    'piket_harian': true,
    'piket_sebelum': true,
    'tugas_kelas': false,
    'kegiatan_mendatang': true,
    'rapat_kelas': false,
    'deadline_tugas': true,
    'laporan_piket': true,
    'absensi_harian': false,
  };

  Map<String, TimeOfDay> reminderTimes = {
    'piket_harian': const TimeOfDay(hour: 7, minute: 0),
    'piket_sebelum': const TimeOfDay(hour: 6, minute: 30),
    'tugas_kelas': const TimeOfDay(hour: 19, minute: 0),
    'kegiatan_mendatang': const TimeOfDay(hour: 8, minute: 0),
    'rapat_kelas': const TimeOfDay(hour: 18, minute: 0),
    'deadline_tugas': const TimeOfDay(hour: 20, minute: 0),
    'laporan_piket': const TimeOfDay(hour: 15, minute: 0),
    'absensi_harian': const TimeOfDay(hour: 7, minute: 15),
  };

  Map<String, int> reminderFrequency = {
    'piket_harian': 1, // Harian
    'piket_sebelum': 1, // Harian
    'tugas_kelas': 2, // Mingguan
    'kegiatan_mendatang': 1, // Harian
    'rapat_kelas': 2, // Mingguan
    'deadline_tugas': 3, // Custom
    'laporan_piket': 1, // Harian
    'absensi_harian': 1, // Harian
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildReminderSections(),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Pengingat Otomatis',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF212121),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
          tooltip: 'Bantuan',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF4CAF50).withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.className,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Atur pengingat untuk kegiatan kelas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pengingat akan dikirim ke semua anggota kelas yang aktif',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
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

  Widget _buildReminderSections() {
    return Column(
      children: [
        _buildReminderSection(
          'Pengingat Piket',
          'Notifikasi terkait jadwal piket kelas',
          Icons.cleaning_services_outlined,
          const Color(0xFF4CAF50),
          [
            _buildReminderItem(
              'piket_harian',
              'Pengingat Piket Harian',
              'Ingatkan petugas piket setiap hari',
              Icons.today_outlined,
            ),
            _buildReminderItem(
              'piket_sebelum',
              'Pengingat Sebelum Piket',
              'Ingatkan 30 menit sebelum jadwal piket',
              Icons.alarm_outlined,
            ),
            _buildReminderItem(
              'laporan_piket',
              'Laporan Status Piket',
              'Minta laporan status piket harian',
              Icons.assignment_outlined,
            ),
          ],
        ),
        _buildReminderSection(
          'Pengingat Kegiatan',
          'Notifikasi untuk kegiatan dan tugas kelas',
          Icons.event_outlined,
          const Color(0xFF2196F3),
          [
            _buildReminderItem(
              'kegiatan_mendatang',
              'Kegiatan Mendatang',
              'Ingatkan kegiatan kelas yang akan datang',
              Icons.event_available_outlined,
            ),
            _buildReminderItem(
              'tugas_kelas',
              'Tugas Kelas',
              'Ingatkan tugas dan PR yang harus dikerjakan',
              Icons.assignment_turned_in_outlined,
            ),
            _buildReminderItem(
              'deadline_tugas',
              'Deadline Tugas',
              'Peringatan mendekati deadline tugas',
              Icons.schedule_outlined,
            ),
          ],
        ),
        _buildReminderSection(
          'Pengingat Administratif',
          'Notifikasi untuk urusan administratif kelas',
          Icons.admin_panel_settings_outlined,
          const Color(0xFF9C27B0),
          [
            _buildReminderItem(
              'rapat_kelas',
              'Rapat Kelas',
              'Ingatkan jadwal rapat atau pertemuan kelas',
              Icons.groups_outlined,
            ),
            _buildReminderItem(
              'absensi_harian',
              'Absensi Harian',
              'Pengingat untuk mengisi absensi harian',
              Icons.how_to_reg_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderSection(String title, String subtitle, IconData icon, Color color, List<Widget> items) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(color: color.withOpacity(0.2), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildReminderItem(String key, String title, String subtitle, IconData icon) {
    bool isEnabled = reminderSettings[key] ?? false;
    TimeOfDay time = reminderTimes[key] ?? const TimeOfDay(hour: 8, minute: 0);
    int frequency = reminderFrequency[key] ?? 1;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0).withOpacity(0.5), width: 1),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isEnabled ? const Color(0xFF4CAF50).withOpacity(0.15) : Colors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isEnabled ? const Color(0xFF4CAF50) : Colors.grey,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) {
            setState(() {
              reminderSettings[key] = value;
            });
          },
          activeColor: const Color(0xFF4CAF50),
        ),
        children: isEnabled ? [
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(key, time),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFrequencySelector(key, frequency),
              ),
            ],
          ),
        ] : [],
      ),
    );
  }

  Widget _buildTimeSelector(String key, TimeOfDay time) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          setState(() {
            reminderTimes[key] = picked;
          });
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Color(0xFF4CAF50)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waktu',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    time.format(context),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySelector(String key, int frequency) {
    final frequencies = ['Harian', 'Mingguan', 'Custom'];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.repeat, size: 18, color: Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frekuensi',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                DropdownButton<int>(
                  value: frequency,
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  items: frequencies.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key + 1,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        reminderFrequency[key] = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _resetToDefaults,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF9E9E9E)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset Default',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan Pengaturan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      reminderSettings = {
        'piket_harian': true,
        'piket_sebelum': true,
        'tugas_kelas': false,
        'kegiatan_mendatang': true,
        'rapat_kelas': false,
        'deadline_tugas': true,
        'laporan_piket': true,
        'absensi_harian': false,
      };
      
      reminderTimes = {
        'piket_harian': const TimeOfDay(hour: 7, minute: 0),
        'piket_sebelum': const TimeOfDay(hour: 6, minute: 30),
        'tugas_kelas': const TimeOfDay(hour: 19, minute: 0),
        'kegiatan_mendatang': const TimeOfDay(hour: 8, minute: 0),
        'rapat_kelas': const TimeOfDay(hour: 18, minute: 0),
        'deadline_tugas': const TimeOfDay(hour: 20, minute: 0),
        'laporan_piket': const TimeOfDay(hour: 15, minute: 0),
        'absensi_harian': const TimeOfDay(hour: 7, minute: 15),
      };
    });
    
    _showSnackbar('Pengaturan dikembalikan ke default', const Color(0xFF4CAF50));
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi penyimpanan pengaturan
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Di sini Anda bisa menambahkan logika untuk menyimpan ke database/shared preferences
      
      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'message': 'Pengaturan pengingat berhasil disimpan',
          'data': {
            'settings': reminderSettings,
            'times': reminderTimes.map((key, value) => MapEntry(key, '${value.hour}:${value.minute}')),
            'frequencies': reminderFrequency,
          },
        });
      }
    } catch (e) {
      if (mounted) {
        _showSnackbar('Gagal menyimpan pengaturan: ${e.toString()}', const Color(0xFFF44336));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan Pengingat Otomatis'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cara Menggunakan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Aktifkan pengingat yang diinginkan dengan toggle switch'),
              SizedBox(height: 4),
              Text('2. Tap pada item pengingat untuk mengatur waktu dan frekuensi'),
              SizedBox(height: 4),
              Text('3. Pilih waktu pengingat yang sesuai'),
              SizedBox(height: 4),
              Text('4. Tentukan frekuensi: Harian, Mingguan, atau Custom'),
              SizedBox(height: 4),
              Text('5. Klik "Simpan Pengaturan" untuk menyimpan'),
              SizedBox(height: 12),
              Text(
                'Catatan:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Pengingat akan dikirim ke semua anggota kelas'),
              Text('• Pastikan notifikasi aplikasi sudah aktif'),
              Text('• Pengaturan dapat diubah kapan saja'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == const Color(0xFF4CAF50) ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}