import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  final String className;
  final Map<String, dynamic>? initialPrivacySettings;

  const PrivacySettingsPage({
    super.key,
    required this.className,
    this.initialPrivacySettings,
  });

  @override
  PrivacySettingsPageState createState() => PrivacySettingsPageState();
}

class PrivacySettingsPageState extends State<PrivacySettingsPage> {
  // Privacy Settings
  ClassVisibility _classVisibility = ClassVisibility.public;
  bool _allowJoinRequests = true;
  bool _showMemberList = true;
  bool _allowMemberInvitations = true;
  bool _showClassActivities = true;
  bool _allowGuestView = false;
  bool _requireApprovalForPosts = false;
  bool _showClassSchedule = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  void _loadInitialSettings() {
    if (widget.initialPrivacySettings != null) {
      final settings = widget.initialPrivacySettings!;
      
      setState(() {
        _classVisibility = ClassVisibility.values.firstWhere(
          (e) => e.name == settings['visibility'],
          orElse: () => ClassVisibility.public,
        );
        _allowJoinRequests = settings['allowJoinRequests'] ?? true;
        _showMemberList = settings['showMemberList'] ?? true;
        _allowMemberInvitations = settings['allowMemberInvitations'] ?? true;
        _showClassActivities = settings['showClassActivities'] ?? true;
        _allowGuestView = settings['allowGuestView'] ?? false;
        _requireApprovalForPosts = settings['requireApprovalForPosts'] ?? false;
        _showClassSchedule = settings['showClassSchedule'] ?? true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            _buildVisibilitySection(),
            _buildAccessControlSection(),
            _buildContentVisibilitySection(),
            _buildModerationSection(),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Pengaturan Privasi',
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
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF44336).withOpacity(0.1),
            const Color(0xFFF44336).withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF44336).withOpacity(0.2)),
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
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF44336),
                  const Color(0xFFF44336).withOpacity(0.8)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF44336).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.security_outlined,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kelola privasi dan keamanan kelas Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
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

  Widget _buildVisibilitySection() {
    return _buildSection(
      title: 'Visibilitas Kelas',
      subtitle: 'Tentukan siapa yang dapat melihat kelas ini',
      icon: Icons.visibility_outlined,
      color: const Color(0xFF2196F3),
      child: Column(
        children: [
          _buildVisibilityOption(
            ClassVisibility.public,
            'Publik',
            'Semua orang dapat melihat dan bergabung dengan kelas',
            Icons.public,
          ),
          _buildVisibilityOption(
            ClassVisibility.private,
            'Private',
            'Hanya anggota yang diundang dapat melihat kelas',
            Icons.lock_outline,
          ),
          _buildVisibilityOption(
            ClassVisibility.restricted,
            'Terbatas',
            'Dapat dilihat publik, tapi perlu persetujuan untuk bergabung',
            Icons.supervised_user_circle_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessControlSection() {
    return _buildSection(
      title: 'Kontrol Akses',
      subtitle: 'Atur cara orang bergabung dengan kelas',
      icon: Icons.group_add_outlined,
      color: const Color(0xFF4CAF50),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.person_add_outlined,
            title: 'Izinkan Permintaan Bergabung',
            subtitle: 'Orang lain dapat meminta untuk bergabung',
            value: _allowJoinRequests,
            onChanged: (value) => setState(() => _allowJoinRequests = value),
            enabled: _classVisibility != ClassVisibility.private,
          ),
          _buildSwitchTile(
            icon: Icons.send_outlined,
            title: 'Izinkan Undangan Anggota',
            subtitle: 'Anggota dapat mengundang orang lain',
            value: _allowMemberInvitations,
            onChanged: (value) => setState(() => _allowMemberInvitations = value),
          ),
          _buildSwitchTile(
            icon: Icons.visibility_outlined,
            title: 'Izinkan Tamu Melihat',
            subtitle: 'Non-anggota dapat melihat konten dasar',
            value: _allowGuestView,
            onChanged: (value) => setState(() => _allowGuestView = value),
            enabled: _classVisibility == ClassVisibility.public,
          ),
        ],
      ),
    );
  }

  Widget _buildContentVisibilitySection() {
    return _buildSection(
      title: 'Visibilitas Konten',
      subtitle: 'Tentukan konten apa yang dapat dilihat orang lain',
      icon: Icons.content_copy_outlined,
      color: const Color(0xFF9C27B0),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.people_outline,
            title: 'Tampilkan Daftar Anggota',
            subtitle: 'Orang lain dapat melihat siapa saja anggota kelas',
            value: _showMemberList,
            onChanged: (value) => setState(() => _showMemberList = value),
          ),
          _buildSwitchTile(
            icon: Icons.timeline_outlined,
            title: 'Tampilkan Aktivitas Kelas',
            subtitle: 'Aktivitas terbaru kelas dapat dilihat',
            value: _showClassActivities,
            onChanged: (value) => setState(() => _showClassActivities = value),
          ),
          _buildSwitchTile(
            icon: Icons.schedule_outlined,
            title: 'Tampilkan Jadwal Kelas',
            subtitle: 'Jadwal piket dan kegiatan dapat dilihat',
            value: _showClassSchedule,
            onChanged: (value) => setState(() => _showClassSchedule = value),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationSection() {
    return _buildSection(
      title: 'Moderasi Konten',
      subtitle: 'Kontrol konten yang diposting di kelas',
      icon: Icons.admin_panel_settings_outlined,
      color: const Color(0xFFFF9800),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.approval_outlined,
            title: 'Persetujuan untuk Postingan',
            subtitle: 'Semua postingan perlu disetujui sebelum tampil',
            value: _requireApprovalForPosts,
            onChanged: (value) => setState(() => _requireApprovalForPosts = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
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
                bottom: BorderSide(color: color.withOpacity(0.2)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
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
                        style: const TextStyle(
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
          child,
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(
    ClassVisibility visibility,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _classVisibility == visibility;
    final color = const Color(0xFF2196F3);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : const Color(0xFFE0E0E0),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _classVisibility = visibility),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : Colors.grey[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? color.withOpacity(0.8) : const Color(0xFF757575),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: enabled 
                    ? (value ? const Color(0xFF4CAF50).withOpacity(0.15) : Colors.grey.withOpacity(0.1))
                    : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: enabled 
                    ? (value ? const Color(0xFF4CAF50) : Colors.grey[600])
                    : Colors.grey[400],
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: enabled ? Colors.black87 : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: enabled ? const Color(0xFF757575) : Colors.grey[400],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeColor: const Color(0xFF4CAF50),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _savePrivacySettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
        ),
        child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
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
    );
  }

  Future<void> _savePrivacySettings() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final privacySettings = {
        'visibility': _classVisibility.name,
        'allowJoinRequests': _allowJoinRequests,
        'showMemberList': _showMemberList,
        'allowMemberInvitations': _allowMemberInvitations,
        'showClassActivities': _showClassActivities,
        'allowGuestView': _allowGuestView,
        'requireApprovalForPosts': _requireApprovalForPosts,
        'showClassSchedule': _showClassSchedule,
      };

      // Return result to previous page
      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'message': 'Pengaturan privasi berhasil disimpan',
          'data': privacySettings,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Gagal menyimpan: ${e.toString()}')),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

enum ClassVisibility {
  public,
  private,
  restricted,
}