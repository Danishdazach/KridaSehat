import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  // Callback untuk memperbarui jumlah notifikasi
  final Function(int) onNotificationUpdate;
  // Jumlah notifikasi yang belum dibaca
  final int unreadCount;

  // Menggunakan super parameter untuk 'key'
  const NotificationWidget({
    required this.onNotificationUpdate,
    this.unreadCount = 0,
    super.key, // Passing 'key' to the super class constructor
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  // Daftar notifikasi dalam aplikasi
  final List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    // Contoh data notifikasi (dalam implementasi sebenarnya, data ini akan diambil dari server/API)
    _loadSampleNotifications();
  }

  // Fungsi untuk memuat contoh notifikasi
  void _loadSampleNotifications() {
    _notifications.addAll([
      NotificationItem(
        id: '1',
        title: 'Selamat datang di KridaSehat!',
        message: 'Terima kasih telah bergabung dengan KridaSehat. Lengkapi profil Anda untuk pengalaman yang lebih baik.',
        type: NotificationType.welcome,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Pengingat Kesehatan',
        message: 'Jangan lupa untuk mengisi catatan kesehatan harian Anda hari ini.',
        type: NotificationType.reminder,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ]);

    // Update jumlah notifikasi yang belum dibaca
    _updateUnreadCount();
  }

  // Fungsi untuk menandai notifikasi sebagai telah dibaca
  void _markAsRead(String id) {
    setState(() {
      for (var notification in _notifications) {
        if (notification.id == id && !notification.isRead) {
          notification.isRead = true;
          break;
        }
      }
      _updateUnreadCount();
    });
  }

  // Fungsi untuk menandai semua notifikasi sebagai telah dibaca
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
      _updateUnreadCount();
    });
  }

  // Fungsi untuk menghapus notifikasi
  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
      _updateUnreadCount();
    });
  }

  // Fungsi untuk menghitung jumlah notifikasi yang belum dibaca
  void _updateUnreadCount() {
    final unreadCount = _notifications.where((notification) => !notification.isRead).length;
    widget.onNotificationUpdate(unreadCount);
  }

  // Fungsi untuk menampilkan ikon berdasarkan jenis notifikasi
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return Icons.waving_hand;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.announcement:
        return Icons.campaign;
      case NotificationType.alert:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  // Fungsi untuk menampilkan warna berdasarkan jenis notifikasi
  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.announcement:
        return Colors.orange;
      case NotificationType.alert:
        return Colors.red;
      case NotificationType.info:
        return Colors.purple;
      default:
        return const Color(0xFF6E7E40);
    }
  }

  // Format waktu relatif untuk notifikasi
  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Widget untuk menampilkan item notifikasi
  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFFF5F7EA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead ? Colors.grey.shade200 : const Color(0xFFDCE2C0),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 13,
                color: notification.isRead ? Colors.grey.shade600 : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _getRelativeTime(notification.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        onTap: () {
          _markAsRead(notification.id);
          // Tampilkan detail notifikasi
          _showNotificationDetail(notification);
        },
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => _deleteNotification(notification.id),
          tooltip: 'Hapus notifikasi',
        ),
      ),
    );
  }

  // Dialog untuk menampilkan detail notifikasi
  void _showNotificationDetail(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Diterima: ${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year} ${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai semua dibaca',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anda akan menerima notifikasi penting di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
    );
  }
}

// Kelas untuk item notifikasi
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

// Enum untuk jenis notifikasi
enum NotificationType {
  welcome,
  reminder,
  announcement,
  alert,
  info,
}

// Widget untuk menampilkan badge notifikasi
class NotificationBadge extends StatelessWidget {
  final int count;
  final Color color;

  const NotificationBadge({
    super.key, // Directly pass the key to the superclass constructor
    required this.count,
    this.color = const Color(0xFFE74C3C),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Text(
        count > 9 ? '9+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Helper untuk menampilkan panel notifikasi
class NotificationHelper {
  // Fungsi statis untuk menampilkan panel notifikasi
  static void showNotificationPanel(BuildContext context, {required Function(int) onNotificationUpdate, int unreadCount = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationWidget(
          onNotificationUpdate: onNotificationUpdate,
          unreadCount: unreadCount,
        ),
      ),
    );
  }
}
