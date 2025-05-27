import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import '../widgets/app_theme.dart';


// Color Palette untuk Aplikasi Piket
class PiketColors {
  static const Color primaryLight = Color(0xFF8FA663);   // Hijau medium
  static const Color accent = Color(0xFF8FA663);         // Hijau cerah untuk tombol
  static const Color success = Color(0xFF66BB6A);        // Hijau sukses
  static const Color badge = Color(0xFF8FA663);          // Hijau lembut untuk badge
  static const Color surface = Color(0xFFE8F5E8);       // Hijau sangat terang untuk background
}


enum AppBarLayout {
  standard,       // Title + greeting
  compact,        // Title only dengan badge kelas
  detailed,       // Full info dengan sekolah
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final UserModel user;
  final VoidCallback? onNotificationTap;
  final AppBarLayout layout;
  final bool showGreeting;
  final bool showGrade;

  const CustomAppBar({
    super.key, 
    required this.title,
    required this.user,
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
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _updateNotificationCount();
    _notificationService.addListener(_onNotificationChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationChanged);
    super.dispose();
  }

  void _onNotificationChanged() {
    if (mounted) {
      setState(() {
        _updateNotificationCount();
      });
    }
  }

  void _updateNotificationCount() {
    _notificationCount = _notificationService.unreadCount;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor, // Hijau gelap profesional
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
    String firstName = widget.user.getFirstName();
    
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
            if (widget.showGrade && widget.user.grade != null) ...[
              const SizedBox(width: 8),
              _buildGradeBadge(),
            ],
          ],
        ),
        if (widget.showGreeting) ...[
          const SizedBox(height: 2),
          Text(
            'Halo, $firstName! 🧹',
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
        if (widget.showGrade && widget.user.grade != null) _buildGradeBadge(),
      ],
    );
  }

  Widget _buildDetailedTitle() {
    String firstName = widget.user.getFirstName();
    
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
        if (widget.showGreeting)
          Text(
            'Halo, $firstName! 🧹',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (widget.user.grade != null) _buildGradeBadge(),
            if (widget.user.school != null) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.user.school!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
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
        widget.user.getGradeInfo(),
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
        child: widget.user.profileImageUrl != null
            ? ClipOval(
                child: Image.network(
                  widget.user.profileImageUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildInitialsAvatar();
                  },
                ),
              )
            : _buildInitialsAvatar(),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Text(
      widget.user.getInitials(),
      style: const TextStyle(
        color: AppTheme.primaryColor, // Hijau gelap untuk inisial
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

// Usage examples untuk aplikasi piket
class PiketAppBarExamples {
  // Standard layout untuk beranda piket
  static Widget piketHomeAppBar(UserModel user, VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Piket Harian',
      user: user,
      layout: AppBarLayout.standard,
      showGreeting: true,
      showGrade: true,
      onNotificationTap: onNotificationTap,
    );
  }

  // Compact untuk jadwal piket
  static Widget jadwalPiketAppBar(UserModel user, VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Jadwal Piket',
      user: user,
      layout: AppBarLayout.compact,
      showGreeting: false,
      showGrade: true,
      onNotificationTap: onNotificationTap,
    );
  }

  // Detailed untuk dashboard piket
  static Widget dashboardPiketAppBar(UserModel user, VoidCallback onNotificationTap) {
    return CustomAppBar(
      title: 'Dashboard Piket',
      user: user,
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