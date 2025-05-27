import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../screens/beranda/user_profile_state.dart'; // Import UserProfileState

// Color Palette untuk Aplikasi Piket
class PiketColors {
  static const Color primary = Color(0xFF2E7D32);        // Hijau gelap profesional
  static const Color primaryLight = Color(0xFF4CAF50);   // Hijau medium
  static const Color accent = Color(0xFF43A047);         // Hijau cerah untuk tombol
  static const Color success = Color(0xFF66BB6A);        // Hijau sukses
  static const Color badge = Color(0xFF81C784);          // Hijau lembut untuk badge
  static const Color surface = Color(0xFFE8F5E8);       // Hijau sangat terang untuk background
}

enum AppBarLayout {
  standard,       // Title + greeting
  compact,        // Title only dengan badge kelas
  detailed,       // Full info dengan sekolah
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final AppBarLayout layout;
  final bool showGreeting;
  final bool showGrade;

  const CustomAppBar({
    super.key, 
    required this.title,
    this.onNotificationTap,
    this.layout = AppBarLayout.standard,
    this.showGreeting = true,
    this.showGrade = true,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
    layout == AppBarLayout.detailed ? 80 : kToolbarHeight
  );
}

class _CustomAppBarState extends State<CustomAppBar> {
  final NotificationService _notificationService = NotificationService();
  final UserProfileState _profileState = UserProfileState();
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _updateNotificationCount();
    _notificationService.addListener(_onNotificationChanged);
    _profileState.addListener(_onProfileChanged);
    _loadProfile();
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationChanged);
    _profileState.removeListener(_onProfileChanged);
    super.dispose();
  }

  Future<void> _loadProfile() async {
    await _profileState.loadProfileStatus();
    if (mounted) {
      setState(() {});
    }
  }

  void _onNotificationChanged() {
    if (mounted) {
      setState(() {
        _updateNotificationCount();
      });
    }
  }

  void _onProfileChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateNotificationCount() {
    _notificationCount = _notificationService.unreadCount;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PiketColors.primary, // Hijau gelap profesional
      elevation: 2,
      toolbarHeight: widget.layout == AppBarLayout.detailed ? 80 : kToolbarHeight,
      leading: Builder(
        builder: (context) => IconButton(
          icon: _buildProfileIcon(),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Buka Menu Profil',
        ),
      ),
      title: _buildTitle(),
      centerTitle: false,
      actions: [
        _buildNotificationButton(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTitle() {
    switch (widget.layout) {
      case AppBarLayout.compact:
        return _buildCompactTitle();
      case AppBarLayout.detailed:
        return _buildDetailedTitle();
      case AppBarLayout.standard:
        return _buildStandardTitle();
    }
  }

  Widget _buildStandardTitle() {
    String displayName = _getDisplayName();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.showGrade && _profileState.userClass.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildGradeBadge(),
            ],
          ],
        ),
        if (widget.showGreeting && displayName.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            'Halo, $displayName! 🧹',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompactTitle() {
    return Row(
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (widget.showGrade && _profileState.userClass.isNotEmpty) _buildGradeBadge(),
      ],
    );
  }

  Widget _buildDetailedTitle() {
    String displayName = _getDisplayName();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        if (widget.showGreeting && displayName.isNotEmpty)
          Text(
            'Halo, $displayName! 🧹',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (_profileState.userClass.isNotEmpty) _buildGradeBadge(),
            // Jika ada sekolah dari profil, bisa ditambahkan di sini
            // if (_profileState.userSchool.isNotEmpty) ...[
            //   const SizedBox(width: 8),
            //   Flexible(
            //     child: Text(
            //       _profileState.userSchool,
            //       style: TextStyle(
            //         color: Colors.white.withOpacity(0.8),
            //         fontSize: 10,
            //         fontWeight: FontWeight.w400,
            //       ),
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ),
            // ],
          ],
        ),
      ],
    );
  }

  String _getDisplayName() {
    if (_profileState.userName.isNotEmpty) {
      // Ambil nama depan dari nama lengkap
      List<String> nameParts = _profileState.userName.split(' ');
      return nameParts.first;
    }
    return '';
  }

  String _getInitials() {
    if (_profileState.userName.isNotEmpty) {
      List<String> nameParts = _profileState.userName.split(' ');
      if (nameParts.length >= 2) {
        return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty) {
        return nameParts[0].substring(0, nameParts[0].length >= 2 ? 2 : 1).toUpperCase();
      }
    }
    return '?';
  }

  Widget _buildGradeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: PiketColors.badge.withOpacity(0.3), // Hijau lembut transparan
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PiketColors.badge.withOpacity(0.5)),
      ),
      child: Text(
        _profileState.userClass,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.white,
        child: _buildInitialsAvatar(),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Text(
      _getInitials(),
      style: const TextStyle(
        color: PiketColors.primary, // Hijau gelap untuk inisial
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            print('Notification button pressed!');
            if (widget.onNotificationTap != null) {
              print('Calling custom notification callback');
              widget.onNotificationTap!();
            } else {
              print('No custom callback provided');
            }
          },
          tooltip: 'Notifikasi',
        ),
        // Badge notifikasi dengan warna accent
        if (_notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: PiketColors.accent, // Hijau cerah untuk badge notifikasi
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _notificationCount > 99 ? '99+' : _notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Usage examples untuk aplikasi piket (Updated - tidak perlu parameter user lagi)
class PiketAppBarExamples {
  // Standard layout untuk beranda piket
  static Widget piketHomeAppBar(VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Piket Harian',
      layout: AppBarLayout.standard,
      showGreeting: true,
      showGrade: true,
      onNotificationTap: onNotificationTap,
    );
  }

  // Compact untuk jadwal piket
  static Widget jadwalPiketAppBar(VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Jadwal Piket',
      layout: AppBarLayout.compact,
      showGreeting: false,
      showGrade: true,
      onNotificationTap: onNotificationTap,
    );
  }

  // Detailed untuk dashboard piket
  static Widget dashboardPiketAppBar(VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Dashboard Piket',
      layout: AppBarLayout.detailed,
      showGreeting: true,
      showGrade: true,
      onNotificationTap: onNotificationTap,
    );
  }
}

// Contoh penggunaan warna untuk komponen lain
class PiketButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const PiketButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? PiketColors.accent : PiketColors.success,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}