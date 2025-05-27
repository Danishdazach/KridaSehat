import 'package:flutter/material.dart';

class ScheduleSettingsPage extends StatefulWidget {
  final String className;
  final String waliKelas;
  final List<Map<String, dynamic>> anggotaKelas;
  final Map<String, List<String>> initialJadwalPiket;

  const ScheduleSettingsPage({
    super.key,
    required this.className,
    required this.waliKelas,
    required this.anggotaKelas,
    required this.initialJadwalPiket,
  });

  @override
  State<ScheduleSettingsPage> createState() => _ScheduleSettingsPageState();
}

class _ScheduleSettingsPageState extends State<ScheduleSettingsPage>
    with SingleTickerProviderStateMixin {
  late Map<String, List<String>> jadwalPiket;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  bool _hasChanges = false;

  final List<String> hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
  ];

  @override
  void initState() {
    super.initState();
    jadwalPiket = Map<String, List<String>>.from(
      widget.initialJadwalPiket.map((key, value) => MapEntry(key, List<String>.from(value))),
    );
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
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildQuickActions(),
                    _buildJadwalPiketSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _hasChanges ? _buildSaveButton() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Atur Jadwal Piket',
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
        onPressed: () => _handleBack(),
        tooltip: 'Kembali',
      ),
      actions: [
        if (_hasChanges)
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetJadwal,
            tooltip: 'Reset',
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.schedule_outlined,
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
                  'Kelola jadwal piket kelas',
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
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Auto Atur',
                  'Atur jadwal otomatis',
                  Icons.auto_fix_high,
                  const Color(0xFF2196F3),
                  _autoArrangeSchedule,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Reset Semua',
                  'Kosongkan semua jadwal',
                  Icons.clear_all,
                  const Color(0xFFF44336),
                  _clearAllSchedule,
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
                  color: color.withOpacity(0.1),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJadwalPiketSection() {
    return Container(
      margin: const EdgeInsets.all(16),
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
                colors: [
                  const Color(0xFF4CAF50).withOpacity(0.1),
                  const Color(0xFF4CAF50).withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(color: const Color(0xFF4CAF50).withOpacity(0.2), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Piket Mingguan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Tap untuk mengatur petugas piket',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...hariList.asMap().entries.map((entry) {
            final index = entry.key;
            final hari = entry.value;
            final isLast = index == hariList.length - 1;
            
            return _buildHariCard(hari, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildHariCard(String hari, bool isLast) {
    final petugasList = jadwalPiket[hari] ?? [];
    
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: const Color(0xFFE0E0E0).withOpacity(0.5), width: 1),
        ),
        borderRadius: isLast ? const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPetugasSelectionDialog(hari),
          borderRadius: isLast ? const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: petugasList.isNotEmpty 
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    hari.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: petugasList.isNotEmpty 
                          ? const Color(0xFF4CAF50)
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hari,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        petugasList.isNotEmpty 
                            ? petugasList.join(', ')
                            : 'Belum ada petugas',
                        style: TextStyle(
                          fontSize: 14,
                          color: petugasList.isNotEmpty 
                              ? Colors.black87
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: petugasList.isNotEmpty 
                        ? const Color(0xFF4CAF50).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    petugasList.isNotEmpty 
                        ? Icons.check_circle_outline
                        : Icons.add,
                    color: petugasList.isNotEmpty 
                        ? const Color(0xFF4CAF50)
                        : Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveJadwal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                    'Simpan Jadwal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showPetugasSelectionDialog(String hari) {
    final selectedPetugas = List<String>.from(jadwalPiket[hari] ?? []);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Pilih Petugas - $hari'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih 2-3 siswa untuk bertugas piket',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.anggotaKelas.map((anggota) {
                        final nama = anggota['nama'] ?? '';
                        final isSelected = selectedPetugas.contains(nama);
                        
                        return CheckboxListTile(
                          title: Text(nama),
                          subtitle: Text('${anggota['no_absen'] ?? ''} - ${anggota['nisn'] ?? ''}'),
                          value: isSelected,
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                if (selectedPetugas.length < 3) {
                                  selectedPetugas.add(nama);
                                }
                              } else {
                                selectedPetugas.remove(nama);
                              }
                            });
                          },
                          activeColor: const Color(0xFF4CAF50),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
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
                  jadwalPiket[hari] = selectedPetugas;
                  _hasChanges = true;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _autoArrangeSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atur Otomatis'),
        content: const Text('Sistem akan mengatur jadwal piket secara otomatis dan merata untuk semua siswa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performAutoArrange();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            child: const Text('Atur Otomatis'),
          ),
        ],
      ),
    );
  }

  void _performAutoArrange() {
    final siswaList = widget.anggotaKelas.map((e) => e['nama'] as String).toList();
    siswaList.shuffle();
    
    int index = 0;
    for (String hari in hariList) {
      final petugasHari = <String>[];
      for (int i = 0; i < 2; i++) {
        if (index < siswaList.length) {
          petugasHari.add(siswaList[index]);
          index++;
        }
      }
      if (index >= siswaList.length) index = 0;
      jadwalPiket[hari] = petugasHari;
    }
    
    setState(() {
      _hasChanges = true;
    });
    
    _showSuccessSnackbar('Jadwal berhasil diatur otomatis');
  }

  void _clearAllSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Jadwal'),
        content: const Text('Apakah Anda yakin ingin menghapus semua jadwal piket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                for (String hari in hariList) {
                  jadwalPiket[hari] = [];
                }
                _hasChanges = true;
              });
              _showSuccessSnackbar('Semua jadwal berhasil dihapus');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _resetJadwal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Jadwal'),
        content: const Text('Kembalikan ke jadwal sebelumnya?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                jadwalPiket = Map<String, List<String>>.from(
                  widget.initialJadwalPiket.map((key, value) => MapEntry(key, List<String>.from(value))),
                );
                _hasChanges = false;
              });
              _showSuccessSnackbar('Jadwal berhasil direset');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveJadwal() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulasi save ke database
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        _showSuccessSnackbar('Jadwal piket berhasil disimpan');
        
        // Return hasil ke halaman sebelumnya
        Navigator.pop(context, {
          'success': true,
          'message': 'Jadwal piket berhasil diperbarui',
          'jadwalPiket': jadwalPiket,
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Gagal menyimpan jadwal: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBack() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Simpan Perubahan'),
          content: const Text('Anda memiliki perubahan yang belum disimpan. Apakah ingin menyimpan terlebih dahulu?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Buang'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveJadwal();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFF44336),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}