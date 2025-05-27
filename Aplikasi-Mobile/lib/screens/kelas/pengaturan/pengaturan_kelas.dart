import 'package:flutter/material.dart';
import '../../beranda/class_management.dart';
import 'edit_class_profile_page.dart';
import 'change_class_photo_page.dart';
import 'edit_anggota.dart';
import 'add_anggota.dart';
import 'permision_page.dart';
import 'pengaturan_privasi.dart';
import 'setting_jadwal.dart';
import 'reminder_setting.dart';

class ClassSettingsPage extends StatefulWidget {
  final ClassInfo? classInfo;
  final Teacher? teacher;
  final String className;
  final String waliKelas;
  final List<Map<String, dynamic>> anggotaKelas;
  final Map<String, List<String>> jadwalPiket;

  const ClassSettingsPage({
    super.key,
    this.classInfo,
    this.teacher,
    required this.className,
    required this.waliKelas,
    required this.anggotaKelas,
    required this.jadwalPiket,
  });

  @override
  ClassSettingsPageState createState() => ClassSettingsPageState();
}

class ClassSettingsPageState extends State<ClassSettingsPage> 
    with SingleTickerProviderStateMixin {
  
  // Design System Constants - Improved naming and organization
  static const _designTokens = _DesignTokens();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late List<SettingSection> _settingSections;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

  void _initializeSettings() {
    _settingSections = [
      SettingSection(
        title: 'Profil Kelas',
        subtitle: 'Kelola informasi dasar kelas',
        icon: Icons.class_outlined,
        color: _AppColors.primary,
        options: [
          SettingOption(
            icon: Icons.edit_outlined,
            title: 'Edit Profil Kelas',
            subtitle: 'Ubah nama kelas, deskripsi, dan informasi dasar',
            color: _AppColors.primary,
            onTap: _handleEditClassProfile,
          ),
          SettingOption(
            icon: Icons.image_outlined,
            title: 'Ganti Foto Kelas',
            subtitle: 'Upload foto profil atau banner kelas',
            color: _AppColors.accent,
            onTap: _handleChangeClassPhoto,
          ),
        ],
      ),
      SettingSection(
        title: 'Anggota & Pengguna',
        subtitle: 'Kelola anggota dan hak akses kelas',
        icon: Icons.people_outline,
        color: _AppColors.info,
        options: [
          SettingOption(
            icon: Icons.person_add_outlined,
            title: 'Tambah Anggota',
            subtitle: 'Undang siswa baru ke kelas',
            color: _AppColors.info,
            onTap: _handleAddMember,
          ),
          SettingOption(
            icon: Icons.edit_outlined,
            title: 'Edit Data Anggota',
            subtitle: 'Ubah informasi anggota kelas',
            color: _AppColors.secondary,
            onTap: _handleEditMembers,
          ),
          SettingOption(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Hak Akses',
            subtitle: 'Atur permission dan role anggota',
            color: _AppColors.accent,
            onTap: _handlePermissions,
          ),
        ],
      ),
      SettingSection(
        title: 'Jadwal & Kegiatan',
        subtitle: 'Atur jadwal piket dan kegiatan kelas',
        icon: Icons.schedule_outlined,
        color: _AppColors.success,
        options: [
          SettingOption(
            icon: Icons.schedule_outlined,
            title: 'Atur Jadwal Piket',
            subtitle: 'Kelola jadwal piket harian kelas',
            color: _AppColors.success,
            onTap: _handleScheduleSettings,
          ),
          SettingOption(
            icon: Icons.notifications_outlined,
            title: 'Pengingat Otomatis',
            subtitle: 'Atur notifikasi untuk kegiatan',
            color: _AppColors.warning,
            onTap: _handleReminders,
          ),
        ],
      ),
      SettingSection(
        title: 'Privasi & Keamanan',
        subtitle: 'Pengaturan privasi dan keamanan kelas',
        icon: Icons.security_outlined,
        color: _AppColors.error,
        options: [
          SettingOption(
            icon: Icons.lock_outline,
            title: 'Pengaturan Privasi',
            subtitle: 'Kontrol siapa yang dapat melihat kelas',
            color: _AppColors.error,
            onTap: _handlePrivacySettings,
          ),
          // SettingOption(
          //   icon: Icons.history_outlined,
          //   title: 'Riwayat Aktivitas',
          //   subtitle: 'Lihat log aktivitas anggota kelas',
          //   color: _AppColors.secondary,
          //   onTap: _handleActivityHistory,
          // ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              ..._settingSections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200 + (index * 100)),
                  curve: Curves.easeOutBack,
                  child: _buildSettingSection(section),
                );
              }),
              SizedBox(height: _designTokens.largeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Pengaturan Kelas',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: _AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali',
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _handleRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(_designTokens.spacing),
      padding: EdgeInsets.all(_designTokens.largeSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_AppColors.primary.withOpacity(0.1), _AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: 'class-icon',
                child: Container(
                  padding: EdgeInsets.all(_designTokens.spacing),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_AppColors.primary, _AppColors.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(_designTokens.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: _AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: _designTokens.iconSize + 8,
                  ),
                ),
              ),
              SizedBox(width: _designTokens.spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.className,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.anggotaKelas.length} anggota kelas',
                      style: TextStyle(
                        fontSize: 14,
                        color: _AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: _designTokens.spacing),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius - 4),
        border: Border.all(color: _AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.person_outline,
            color: _AppColors.primary,
            size: 20,
          ),
          SizedBox(width: _designTokens.smallSpacing),
          Expanded(
            child: Text(
              'Wali Kelas: ${widget.waliKelas}',
              style: TextStyle(
                fontSize: 14,
                color: _AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Aktif',
              style: TextStyle(
                fontSize: 12,
                color: _AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(SettingSection section) {
    return Container(
      margin: EdgeInsets.fromLTRB(_designTokens.spacing, 0, _designTokens.spacing, _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Column(
        children: [
          _buildSectionHeader(section),
          ...section.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isLast = index == section.options.length - 1;
            
            return _buildSettingOption(option, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(SettingSection section) {
    return Container(
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            section.color.withOpacity(0.1), 
            section.color.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(_designTokens.borderRadius)),
        border: Border(
          bottom: BorderSide(color: section.color.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_designTokens.smallSpacing + 2),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(_designTokens.borderRadius - 8),
            ),
            child: Icon(
              section.icon,
              color: section.color,
              size: 20,
            ),
          ),
          SizedBox(width: _designTokens.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  section.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: _AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingOption(SettingOption option, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: _AppColors.borderColor.withOpacity(0.5), width: 1),
        ),
        borderRadius: isLast ? BorderRadius.vertical(
          bottom: Radius.circular(_designTokens.borderRadius),
        ) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: option.onTap,
          borderRadius: isLast ? BorderRadius.vertical(
            bottom: Radius.circular(_designTokens.borderRadius),
          ) : null,
          child: Padding(
            padding: EdgeInsets.all(_designTokens.cardPadding),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(_designTokens.smallSpacing + 2),
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(_designTokens.borderRadius - 8),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.color,
                    size: 18,
                  ),
                ),
                SizedBox(width: _designTokens.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: _AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: option.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: option.color,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handler methods with improved error handling and loading states
// Kemudian ganti method _handleEditClassProfile di ClassSettingsPage menjadi:
Future<void> _handleEditClassProfile() async {
  await _executeWithLoading(() async {
    // Navigate to edit profile page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClassProfilePage(
          initialClassName: widget.className,
          initialWaliKelas: widget.waliKelas,
          initialDescription: '', // Anda bisa tambahkan field ini ke widget jika diperlukan
          initialLocation: '', // Anda bisa tambahkan field ini ke widget jika diperlukan
        ),
      ),
    );

    // Handle hasil dari edit profile
    if (result != null && mounted) {
      // Update data lokal jika diperlukan
      // Atau refresh halaman dengan data terbaru
      _showSuccessSnackbar('Profil kelas berhasil diperbarui');
      
      // Optional: Jika Anda ingin mengupdate state parent widget
      // Anda bisa menggunakan callback atau state management solution
    }
  });
}

Future<void> _handleChangeClassPhoto() async {
  await _executeWithLoading(() async {
    // Navigate to change class photo page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeClassPhotoPage(
          className: widget.className,
          currentPhotoUrl: null, // Bisa diisi dengan URL foto saat ini jika ada
        ),
      ),
    );

    // Handle hasil dari change photo
    if (result != null && result['success'] == true && mounted) {
      _showSuccessSnackbar(result['message'] ?? 'Foto kelas berhasil diperbarui');
      
      // Optional: Update foto di UI atau refresh data
      // Anda bisa menambahkan callback ke parent widget untuk update foto
    }
  });
}

  Future<void> _handleAddMember() async {
  await _executeWithLoading(() async {
    // Navigate to add member page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberPage(
          className: widget.className,
          existingMembers: widget.anggotaKelas,
        ),
      ),
    );

    // Handle hasil dari add member
    if (result != null && result['success'] == true && mounted) {
      final message = result['message'];
      
      // Update local member list (optional - tergantung state management)
      // widget.anggotaKelas.add(newMember);
      
      _showSuccessSnackbar(message ?? 'Anggota berhasil ditambahkan');
      
      // Optional: Callback ke parent widget untuk update data
      // Atau refresh halaman dengan data terbaru
    }
  });
}

  Future<void> _handleEditMembers() async {
    await _executeWithLoading(() async {
      // Navigate ke halaman edit anggota
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditMembersPage(
            className: widget.className,
            waliKelas: widget.waliKelas,
            initialMembers: widget.anggotaKelas,
          ),
        ),
      );

      // Handle hasil dari edit members
      if (result != null && result['success'] == true && mounted) {
        // Update data anggota yang baru jika diperlukan
        // Anda bisa menggunakan callback atau state management untuk update parent widget
        _showSuccessSnackbar(result['message'] ?? 'Data anggota berhasil diperbarui');
        
        // Optional: Jika Anda perlu mengupdate data di parent widget,
        // Anda bisa menambahkan callback function atau menggunakan state management
        // seperti Provider, Bloc, atau Riverpod
        
        // Contoh jika menggunakan callback:
        // if (widget.onMembersUpdated != null) {
      }
      });
    }

  Future<void> _handlePermissions() async {
  await _executeWithLoading(() async {
    // Navigate ke halaman hak akses
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PermissionsPage(
          className: widget.className,
          waliKelas: widget.waliKelas,
          initialMembers: widget.anggotaKelas,
        ),
      ),
    );

    // Handle hasil dari permissions page
    if (result != null && result['success'] == true && mounted) {
      // Update data permissions jika diperlukan
      
      _showSuccessSnackbar(result['message'] ?? 'Hak akses berhasil diperbarui');
      
      // Optional: Jika Anda perlu mengupdate state parent widget,
      // Anda bisa menambahkan callback function atau menggunakan state management
      // seperti Provider, Bloc, atau Riverpod
      
      // Contoh jika menggunakan callback:
      // if (widget.onPermissionsUpdated != null) {
      //   widget.onPermissionsUpdated!(updatedPermissions);
      // }
    }
  });
}

Future<void> _handleScheduleSettings() async {
  await _executeWithLoading(() async {
    // Navigate ke halaman pengaturan jadwal piket
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleSettingsPage(
          className: widget.className,
          waliKelas: widget.waliKelas,
          anggotaKelas: widget.anggotaKelas,
          initialJadwalPiket: widget.jadwalPiket,
        ),
      ),
    );

    // Handle hasil dari schedule settings
    if (result != null && result['success'] == true && mounted) {
      // Update jadwal piket lokal jika diperlukan
      // Anda bisa menggunakan callback untuk mengupdate parent widget
      
      _showSuccessSnackbar(result['message'] ?? 'Jadwal piket berhasil diperbarui');
      
      // Optional: Jika Anda ingin mengupdate jadwalPiket di parent widget,
      // Anda bisa menambahkan callback function atau menggunakan state management
      // seperti Provider, Bloc, atau Riverpod
      
      // Contoh jika menggunakan callback:
      // if (widget.onJadwalPiketUpdated != null) {
      //   widget.onJadwalPiketUpdated!(result['jadwalPiket']);
      // }
    }
  });
}

Future<void> _handleReminders() async {
  await _executeWithLoading(() async {
    // Navigate ke halaman pengaturan pengingat
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReminderSettingsPage(
          className: widget.className,
          waliKelas: widget.waliKelas,
          anggotaKelas: widget.anggotaKelas,
          jadwalPiket: widget.jadwalPiket,
        ),
      ),
    );

    // Handle hasil dari reminder settings
    if (result != null && result['success'] == true && mounted) {
      final reminderData = result['data'];
      
      // Update data pengingat di parent widget jika diperlukan
      // Anda bisa menggunakan callback atau state management untuk menyimpan data
      
      _showSuccessSnackbar(result['message'] ?? 'Pengaturan pengingat berhasil disimpan');
      
      // Optional: Log atau simpan pengaturan pengingat yang baru
      debugPrint('Reminder settings updated: $reminderData');
      
      // Jika Anda ingin mengupdate state parent widget, Anda bisa menambahkan callback:
      // if (widget.onReminderSettingsUpdated != null) {
      //   widget.onReminderSettingsUpdated!(reminderData);
      // }
    }
  });
}

Future<void> _handlePrivacySettings() async {
    await _executeWithLoading(() async {
      // Navigate ke halaman pengaturan privasi
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacySettingsPage(
            className: widget.className,
            initialPrivacySettings: {
              // Anda bisa mengisi dengan data existing jika ada
              'visibility': 'public',
              'allowJoinRequests': true,
              'showMemberList': true,
              'allowMemberInvitations': true,
              'showClassActivities': true,
              'allowGuestView': false,
              'requireApprovalForPosts': false,
              'showClassSchedule': true,
            },
          ),
        ),
      );

      // Handle hasil dari privacy settings
      if (result != null && result['success'] == true && mounted) {
        final privacyData = result['data'];
        
        // Update data privasi di parent widget jika diperlukan
        // Anda bisa menggunakan callback atau state management untuk menyimpan data
        
        _showSuccessSnackbar(result['message'] ?? 'Pengaturan privasi berhasil disimpan');
        
        // Optional: Log atau simpan pengaturan privasi yang baru
        debugPrint('Privacy settings updated: $privacyData');
      }
    });
  }


  // Future<void> _handleActivityHistory() async {
  //   await _executeWithLoading(() async {
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     if (mounted) {
  //       _showSuccessSnackbar('Membuka riwayat aktivitas...');
  //     }
  //   });
  // }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        _showSuccessSnackbar('Data berhasil diperbarui');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Gagal memperbarui data');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Utility methods
  Future<void> _executeWithLoading(Future<void> Function() action) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await action();
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Terjadi kesalahan: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _AppColors.success,
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
            Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Improved Design System
class _DesignTokens {
  const _DesignTokens();
  
  double get borderRadius => 16.0;
  double get cardPadding => 16.0;
  double get spacing => 16.0;
  double get smallSpacing => 8.0;
  double get largeSpacing => 24.0;
  double get iconSize => 24.0;

  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

class _AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF2196F3);
  static const Color accent = Color(0xFF9C27B0);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF00BCD4);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

// Model classes for settings structure
class SettingSection {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<SettingOption> options;

  const SettingSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.options,
  });
}

class SettingOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const SettingOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}