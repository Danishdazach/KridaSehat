import 'package:flutter/material.dart';

// Model untuk role dan permission
class UserRole {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;
  final List<String> permissions;

  const UserRole({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.permissions,
  });
}

class Permission {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String category;

  const Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
  });
}

class MemberPermission {
  final String memberId;
  final String memberName;
  final String roleId;
  final List<String> customPermissions;

  MemberPermission({
    required this.memberId,
    required this.memberName,
    required this.roleId,
    this.customPermissions = const [],
  });

  MemberPermission copyWith({
    String? roleId,
    List<String>? customPermissions,
  }) {
    return MemberPermission(
      memberId: memberId,
      memberName: memberName,
      roleId: roleId ?? this.roleId,
      customPermissions: customPermissions ?? this.customPermissions,
    );
  }
}

class PermissionsPage extends StatefulWidget {
  final String className;
  final String waliKelas;
  final List<Map<String, dynamic>> initialMembers;

  const PermissionsPage({
    super.key,
    required this.className,
    required this.waliKelas,
    required this.initialMembers,
  });

  @override
  PermissionsPageState createState() => PermissionsPageState();
}

class PermissionsPageState extends State<PermissionsPage>
    with SingleTickerProviderStateMixin {
  
  static const _designTokens = _DesignTokens();
  
  late TabController _tabController;
  late List<MemberPermission> _memberPermissions;
  String _searchQuery = '';

  // Data roles dan permissions
  static const List<UserRole> _roles = [
    UserRole(
      id: 'admin',
      name: 'Administrator',
      description: 'Akses penuh ke semua fitur kelas',
      color: _AppColors.primary,
      icon: Icons.admin_panel_settings,
      permissions: [
        'manage_members',
        'edit_class_info',
        'manage_schedule',
        'view_reports',
        'manage_permissions',
        'delete_content',
        'create_announcements',
        'manage_events',
      ],
    ),
    UserRole(
      id: 'moderator',
      name: 'Moderator',
      description: 'Dapat mengelola konten dan anggota',
      color: _AppColors.secondary,
      icon: Icons.security,
      permissions: [
        'manage_members',
        'manage_schedule',
        'view_reports',
        'create_announcements',
        'manage_events',
      ],
    ),
    UserRole(
      id: 'editor',
      name: 'Editor',
      description: 'Dapat mengedit konten dan jadwal',
      color: _AppColors.accent,
      icon: Icons.edit,
      permissions: [
        'edit_class_info',
        'manage_schedule',
        'create_announcements',
      ],
    ),
    UserRole(
      id: 'member',
      name: 'Anggota',
      description: 'Akses dasar untuk melihat konten',
      color: _AppColors.neutral,
      icon: Icons.person,
      permissions: [
        'view_reports',
      ],
    ),
  ];

  static const List<Permission> _permissions = [
    Permission(
      id: 'manage_members',
      name: 'Kelola Anggota',
      description: 'Menambah, mengedit, atau menghapus anggota kelas',
      icon: Icons.people,
      category: 'Anggota',
    ),
    Permission(
      id: 'edit_class_info',
      name: 'Edit Info Kelas',
      description: 'Mengubah informasi dasar kelas',
      icon: Icons.edit,
      category: 'Kelas',
    ),
    Permission(
      id: 'manage_schedule',
      name: 'Kelola Jadwal',
      description: 'Membuat dan mengubah jadwal piket/kegiatan',
      icon: Icons.schedule,
      category: 'Jadwal',
    ),
    Permission(
      id: 'view_reports',
      name: 'Lihat Laporan',
      description: 'Melihat laporan dan statistik kelas',
      icon: Icons.analytics,
      category: 'Laporan',
    ),
    Permission(
      id: 'manage_permissions',
      name: 'Kelola Hak Akses',
      description: 'Mengatur role dan permission anggota',
      icon: Icons.admin_panel_settings,
      category: 'Sistem',
    ),
    Permission(
      id: 'delete_content',
      name: 'Hapus Konten',
      description: 'Menghapus postingan, komentar, dan konten lainnya',
      icon: Icons.delete,
      category: 'Konten',
    ),
    Permission(
      id: 'create_announcements',
      name: 'Buat Pengumuman',
      description: 'Membuat dan mengirim pengumuman kelas',
      icon: Icons.campaign,
      category: 'Komunikasi',
    ),
    Permission(
      id: 'manage_events',
      name: 'Kelola Event',
      description: 'Membuat dan mengelola acara kelas',
      icon: Icons.event,
      category: 'Event',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializePermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializePermissions() {
    _memberPermissions = widget.initialMembers.map((member) {
      // Default role berdasarkan jabatan
      String defaultRole = 'member';
      if (member['nama'] == widget.waliKelas) {
        defaultRole = 'admin';
      } else if (member['jabatan'] == 'Ketua Kelas' || member['jabatan'] == 'Wakil Ketua') {
        defaultRole = 'moderator';
      } else if (member['jabatan'] == 'Sekretaris' || member['jabatan'] == 'Bendahara') {
        defaultRole = 'editor';
      }

      return MemberPermission(
        memberId: member['nisn'].toString(),
        memberName: member['nama'],
        roleId: defaultRole,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(),
                _buildRolesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Hak Akses Kelas',
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
          icon: const Icon(Icons.save_rounded),
          onPressed: _handleSave,
          tooltip: 'Simpan',
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
      child: Row(
        children: [
          Hero(
            tag: 'permissions-icon',
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
                Icons.admin_panel_settings_outlined,
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
                  'Kelola Hak Akses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Atur role dan permission untuk ${widget.className}',
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
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.people),
            text: 'Anggota',
          ),
          Tab(
            icon: Icon(Icons.security),
            text: 'Role & Permission',
          ),
        ],
        labelColor: _AppColors.primary,
        unselectedLabelColor: _AppColors.textSecondary,
        indicatorColor: _AppColors.primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMembersTab() {
    final filteredMembers = _memberPermissions.where((member) {
      return member.memberName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(_designTokens.spacing),
            itemCount: filteredMembers.length,
            itemBuilder: (context, index) {
              final member = filteredMembers[index];
              final role = _roles.firstWhere((r) => r.id == member.roleId);
              
              return _buildMemberCard(member, role);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(_designTokens.spacing),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: _AppColors.textSecondary),
          SizedBox(width: _designTokens.smallSpacing),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari anggota...',
                hintStyle: TextStyle(color: _AppColors.textSecondary),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberPermission member, UserRole role) {
    return Container(
      margin: EdgeInsets.only(bottom: _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(_designTokens.cardPadding),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: role.color.withOpacity(0.2),
              radius: 24,
              child: Text(
                member.memberName[0].toUpperCase(),
                style: TextStyle(
                  color: role.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: _designTokens.spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.memberName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(role.icon, size: 16, color: role.color),
                      const SizedBox(width: 4),
                      Text(
                        role.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: role.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: _AppColors.primary),
              onPressed: () => _showEditMemberDialog(member),
              tooltip: 'Edit Permission',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(_designTokens.spacing),
      itemCount: _roles.length,
      itemBuilder: (context, index) {
        final role = _roles[index];
        return _buildRoleCard(role);
      },
    );
  }

  Widget _buildRoleCard(UserRole role) {
    final memberCount = _memberPermissions.where((m) => m.roleId == role.id).length;
    
    return Container(
      margin: EdgeInsets.only(bottom: _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: role.color.withOpacity(0.3)),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(_designTokens.cardPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [role.color.withOpacity(0.1), role.color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_designTokens.borderRadius),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(_designTokens.smallSpacing + 2),
                  decoration: BoxDecoration(
                    color: role.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(_designTokens.borderRadius - 8),
                  ),
                  child: Icon(role.icon, color: role.color, size: 24),
                ),
                SizedBox(width: _designTokens.spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: _AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: role.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$memberCount anggota',
                    style: TextStyle(
                      fontSize: 12,
                      color: role.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_designTokens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hak Akses:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: _designTokens.smallSpacing),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: role.permissions.map((permId) {
                    final permission = _permissions.firstWhere((p) => p.id == permId);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: role.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: role.color.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(permission.icon, size: 12, color: role.color),
                          const SizedBox(width: 4),
                          Text(
                            permission.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: role.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditMemberDialog(MemberPermission member) {
    showDialog(
      context: context,
      builder: (context) => _EditMemberPermissionDialog(
        member: member,
        roles: _roles,
        permissions: _permissions,
        onSave: (updatedMember) {
          setState(() {
            final index = _memberPermissions.indexWhere((m) => m.memberId == member.memberId);
            if (index != -1) {
              _memberPermissions[index] = updatedMember;
            }
          });
        },
      ),
    );
  }

  Future<void> _handleSave() async {
    
    try {
      // Simulasi save ke backend
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'message': 'Hak akses berhasil diperbarui',
          'permissions': _memberPermissions,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
      }
    }
  }
}

class _EditMemberPermissionDialog extends StatefulWidget {
  final MemberPermission member;
  final List<UserRole> roles;
  final List<Permission> permissions;
  final Function(MemberPermission) onSave;

  const _EditMemberPermissionDialog({
    required this.member,
    required this.roles,
    required this.permissions,
    required this.onSave,
  });

  @override
  _EditMemberPermissionDialogState createState() => _EditMemberPermissionDialogState();
}

class _EditMemberPermissionDialogState extends State<_EditMemberPermissionDialog> {
  late String _selectedRoleId;
  late List<String> _customPermissions;

  @override
  void initState() {
    super.initState();
    _selectedRoleId = widget.member.roleId;
    _customPermissions = List.from(widget.member.customPermissions);
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = widget.roles.firstWhere((r) => r.id == _selectedRoleId);
    
    return AlertDialog(
      title: Text('Edit Hak Akses - ${widget.member.memberName}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Role:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...widget.roles.map((role) => RadioListTile<String>(
              value: role.id,
              groupValue: _selectedRoleId,
              onChanged: (value) {
                setState(() {
                  _selectedRoleId = value!;
                  _customPermissions.clear();
                });
              },
              title: Row(
                children: [
                  Icon(role.icon, color: role.color, size: 20),
                  const SizedBox(width: 8),
                  Text(role.name),
                ],
              ),
              subtitle: Text(role.description),
            )),
            const SizedBox(height: 16),
            const Text('Permission Tambahan:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView(
                children: widget.permissions
                    .where((p) => !selectedRole.permissions.contains(p.id))
                    .map((permission) => CheckboxListTile(
                      value: _customPermissions.contains(permission.id),
                      onChanged: (value) {
                        setState(() {
                          if (value!) {
                            _customPermissions.add(permission.id);
                          } else {
                            _customPermissions.remove(permission.id);
                          }
                        });
                      },
                      title: Row(
                        children: [
                          Icon(permission.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(permission.name),
                        ],
                      ),
                      subtitle: Text(permission.description),
                    ))
                    .toList(),
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
            final updatedMember = widget.member.copyWith(
              roleId: _selectedRoleId,
              customPermissions: _customPermissions,
            );
            widget.onSave(updatedMember);
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

// Design System (sama seperti yang ada di ClassSettingsPage)
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
  static const Color neutral = Color(0xFF9E9E9E);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}