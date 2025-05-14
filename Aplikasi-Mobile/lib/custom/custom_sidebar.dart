import 'package:flutter/material.dart';

/// Widget untuk menu samping kustom (drawer) yang digunakan pada aplikasi KridaSehat
///
/// Menampilkan informasi profil pengguna dan menu navigasi utama
class CustomSidebar extends StatelessWidget {
  // Parameter untuk data pengguna dan fungsi callback
  final String nama;
  final String email;
  final int selectedIndex;
  final Function(int) onItemSelected;
  final Function() onProfileUpdate;

  // Konstanta untuk warna tema
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color drawerHeaderColor = Color(0xFF6E7E40);
  static const Color selectedItemColor = Color(0xFF6E7E40);
  static const Color logoutColor = Colors.red;

  const CustomSidebar({
    super.key,
    required this.nama,
    required this.email,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onProfileUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2.0,
      child: Column(
        children: [
          _buildHeaderSection(),
          _buildNavigationSection(context),
          const Spacer(),
          _buildFooterSection(context),
        ],
      ),
    );
  }

  /// Membangun bagian header yang berisi informasi profil pengguna
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: drawerHeaderColor,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Avatar profil
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: primaryColor),
              ),
            ),
            const SizedBox(width: 16),
            
            // Informasi pengguna (nama dan email)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nama.isNotEmpty ? nama : 'Nama belum diisi',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tombol edit profil
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                          onPressed: onProfileUpdate,
                          tooltip: 'Edit Profil',
                          iconSize: 18,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.isNotEmpty ? email : 'Email belum diisi',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun daftar navigasi utama aplikasi
  Widget _buildNavigationSection(BuildContext context) {
    // Daftarkan semua item navigasi utama
    final List<_DrawerMenuItem> mainMenuItems = [
      _DrawerMenuItem(
        icon: Icons.home,
        title: 'Beranda',
        index: 0,
      ),
      _DrawerMenuItem(
        icon: Icons.person,
        title: 'Profil',
        index: 1,
      ),
      _DrawerMenuItem(
        icon: Icons.settings,
        title: 'Pengaturan',
        index: 2,
      ),
    ];

    // Daftarkan item navigasi tambahan
    final List<_DrawerMenuItem> additionalMenuItems = [
      _DrawerMenuItem(
        icon: Icons.info,
        title: 'Tentang Aplikasi',
        onTap: () {
          Navigator.pop(context); // Tutup drawer dulu
          _showAboutDialog(context);
        },
      ),
      _DrawerMenuItem(
        icon: Icons.help,
        title: 'Bantuan',
        onTap: () {
          Navigator.pop(context);
          // Tambahkan navigasi ke halaman bantuan di sini
        },
      ),
    ];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        // Render item menu utama
        ...mainMenuItems.map((item) => _buildMenuItem(context, item)),
        
        const Divider(height: 16, thickness: 0.8),
        
        // Render item menu tambahan
        ...additionalMenuItems.map((item) => _buildMenuItem(context, item)),
      ],
    );
  }

  /// Membangun bagian footer yang berisi tombol keluar
  Widget _buildFooterSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 0, thickness: 0.8),
        ListTile(
          leading: const Icon(Icons.logout, color: logoutColor),
          title: const Text('Keluar', style: TextStyle(color: logoutColor)),
          dense: true,
          onTap: () => _showLogoutConfirmation(context),
        ),
      ],
    );
  }

  /// Membangun item menu tunggal untuk navigasi
  Widget _buildMenuItem(BuildContext context, _DrawerMenuItem item) {
    final bool isSelected = item.index != null && item.index == selectedIndex;
    
    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? selectedItemColor : null,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? selectedItemColor : null,
        ),
      ),
      onTap: item.onTap ?? () {
        if (item.index != null) {
          onItemSelected(item.index!);
          Navigator.pop(context);
        }
      },
      selected: isSelected,
      dense: true,
      selectedTileColor: selectedItemColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  /// Menampilkan dialog tentang aplikasi
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'KridaSehat',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.sports,
          size: 36,
          color: primaryColor,
        ),
      ),
      children: const [
        SizedBox(height: 16),
        Text(
          'KridaSehat adalah aplikasi yang membantu siswa untuk belajar tentang kesehatan dan olahraga.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Aplikasi ini dikembangkan untuk memudahkan siswa dan guru dalam memantau aktivitas kesehatan dan olahraga di sekolah.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  /// Menampilkan dialog konfirmasi logout
  void _showLogoutConfirmation(BuildContext context) {
    Navigator.pop(context); // Tutup drawer dulu
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear saved data and navigate to login
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: logoutColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

/// Class helper untuk item menu drawer
class _DrawerMenuItem {
  final IconData icon;
  final String title;
  final int? index;
  final Function()? onTap;

  _DrawerMenuItem({
    required this.icon,
    required this.title,
    this.index,
    this.onTap,
  });
}  