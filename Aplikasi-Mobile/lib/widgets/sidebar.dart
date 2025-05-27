import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import 'app_theme.dart';
import 'profile_settings_page.dart';
import 'profile.dart';

class ProfileSidebar extends StatelessWidget {
  final UserModel user;
  final NotificationService notificationService;
  final VoidCallback onNotificationTap;

  const ProfileSidebar({
    super.key,
    required this.user,
    required this.notificationService,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.person_rounded,
            title: 'Profil',
            onTap: () {
              Navigator.pop(context); // Tutup drawer dulu
              // Navigate ke ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          _buildNotificationDrawerItem(context),
          _buildDrawerItem(
            icon: Icons.settings_rounded,
            title: 'Pengaturan',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsPage(user: user),
                ),
              );
            },
          ),
          const Divider(color: Colors.grey, height: 1),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
            textColor: Colors.red[600],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: user.profileImageUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user.profileImageUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              user.getInitials(),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        user.getInitials(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              user.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Level ${user.level} • ${user.points} poin 🏆',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: textColor == null 
              ? AppTheme.backgroundColor 
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildNotificationDrawerItem(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            const Icon(
              Icons.notifications_rounded,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            if (notificationService.hasUnreadNotifications)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${notificationService.unreadCount > 9 ? '9+' : notificationService.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      title: const Text(
        'Notifikasi',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onNotificationTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Mencegah dialog ditutup dengan tap di luar
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Mencegah dialog ditutup dengan tombol back
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          actionsPadding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 16,
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Konfirmasi Keluar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Anda akan kehilangan sesi aktif dan perlu login kembali.',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _performLogout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Keluar',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    // Tutup dialog terlebih dahulu
    Navigator.of(context).pop();
    
    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Sedang keluar...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Simulasi proses logout (misal: clear cache, token, dll)
    await Future.delayed(const Duration(seconds: 1));
    
    // Tutup loading dialog
    if (context.mounted) {
      Navigator.of(context).pop();
      
      // Clear semua navigation stack dan arahkan ke login
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
      
      // Tampilkan snackbar konfirmasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Text('Berhasil keluar dari aplikasi'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Tambahan: Method untuk mendukung callback actions
  static ProfileSidebar withCallbacks({
    required UserModel user,
    required NotificationService notificationService,
    required VoidCallback onNotificationTap,
    VoidCallback? onProfileTap,
    VoidCallback? onSettingsTap,
    VoidCallback? onHelpTap,
    VoidCallback? onLogoutTap,
  }) {
    return ProfileSidebar(
      user: user,
      notificationService: notificationService,
      onNotificationTap: onNotificationTap,
    );
  }
}