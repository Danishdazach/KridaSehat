import 'package:flutter/material.dart';
import '../widgets/notification_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nama;
  final String email;
  final int unreadNotifications;
  final VoidCallback onProfilePressed;
  final VoidCallback onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.nama,
    required this.email,
    required this.unreadNotifications,
    required this.onProfilePressed,
    required this.onNotificationPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF6E7E40),
      foregroundColor: Colors.white,
      leadingWidth: 24,
      title: InkWell(
        onTap: onProfilePressed,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Color(0xFF6E7E40), size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama.isNotEmpty ? nama : 'Pengguna',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email.isNotEmpty ? email : 'Selamat datang',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 26),
                onPressed: onNotificationPressed,
              ),
              if (unreadNotifications > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: NotificationBadge(count: unreadNotifications),
                ),
            ],
          ),
        ),
      ],
    );
  }
}