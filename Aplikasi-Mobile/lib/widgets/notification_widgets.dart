import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';

// Widget untuk menampilkan bottom sheet notifikasi
class NotificationBottomSheet extends StatefulWidget {
  final UserModel user;

  const NotificationBottomSheet({
    super.key,
    required this.user,
  });

  @override
  State<NotificationBottomSheet> createState() => _NotificationBottomSheetState();
}

class _NotificationBottomSheetState extends State<NotificationBottomSheet> {
  static const Color primaryColor = Color(0xFF6E7E40);
  
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  NotificationType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _notificationService.addListener(_onNotificationsChanged);
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onNotificationsChanged() {
    if (mounted) {
      setState(() {
        _loadNotifications();
      });
    }
  }

  void _loadNotifications() {
    if (_selectedFilter != null) {
      _notifications = _notificationService.getNotificationsByType(_selectedFilter!);
    } else {
      _notifications = _notificationService.notifications;
    }
  }

  void _filterNotifications(NotificationType? type) {
    setState(() {
      _selectedFilter = type;
      _loadNotifications();
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          _buildFilterSection(),
          Expanded(
            child: _notifications.isEmpty 
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Halo, ${widget.user.getFirstName()}!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (_notificationService.hasUnreadNotifications)
            Container(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _notificationService.markAllAsRead();
                  _showSuccessMessage('Semua notifikasi telah ditandai dibaca');
                },
                child: const Text(
                  'Tandai Semua\nDibaca',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: primaryColor, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'type': null, 'label': 'Semua', 'icon': Icons.all_inclusive},
      {'type': NotificationType.quiz, 'label': 'Kuis', 'icon': Icons.quiz},
      {'type': NotificationType.achievement, 'label': 'Pencapaian', 'icon': Icons.star},
      {'type': NotificationType.reminder, 'label': 'Pengingat', 'icon': Icons.notifications},
      {'type': NotificationType.system, 'label': 'Sistem', 'icon': Icons.settings},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['type'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => _filterNotifications(filter['type'] as NotificationType?),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      size: 14,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      filter['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return NotificationCard(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
          onDismiss: () => _handleNotificationDismiss(notification),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _selectedFilter != null 
                    ? 'Tidak ada notifikasi ${_selectedFilter!.displayName.toLowerCase()}'
                    : 'Tidak ada notifikasi',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Notifikasi baru akan muncul di sini',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    if (!notification.isRead) {
      _notificationService.markAsRead(notification.id);
    }
    
    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.quiz:
        Navigator.pop(context);
        // Add navigation logic here
        break;
      case NotificationType.achievement:
        _showAchievementDialog(notification);
        break;
      case NotificationType.social:
        Navigator.pop(context);
        // Add navigation logic here
        break;
      default:
        break;
    }
  }

  void _handleNotificationDismiss(NotificationModel notification) {
    _notificationService.removeNotification(notification.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notifikasi dihapus'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Batal',
          textColor: Colors.white,
          onPressed: () {
            _notificationService.addNotification(notification);
          },
        ),
      ),
    );
  }

  void _showAchievementDialog(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: notification.type.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                notification.type.icon,
                color: notification.type.color,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Pencapaian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(notification.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

// Widget card untuk menampilkan notifikasi individual
class NotificationCard extends StatelessWidget {
  static const Color primaryColor = Color(0xFF6E7E40);
  
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(height: 4),
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Card(
        elevation: notification.isRead ? 1 : 3,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead 
                ? Colors.grey[200]! 
                : primaryColor.withOpacity(0.3),
            width: notification.isRead ? 1 : 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notification.isRead 
                  ? Colors.white
                  : primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: notification.type.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.type.icon,
                    color: notification.type.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead 
                                    ? FontWeight.w500 
                                    : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: notification.type.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notification.type.displayName,
                              style: TextStyle(
                                fontSize: 10,
                                color: notification.type.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            notification.timeAgo,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class untuk menampilkan notifikasi
class NotificationHelper {
  static void showNotificationBottomSheet(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationBottomSheet(user: user),
    );
  }

  static void showNotificationDialog(BuildContext context, UserModel user) {
    final notificationService = NotificationService();
    final unreadCount = notificationService.unreadCount;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6E7E40).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications, color: Color(0xFF6E7E40)),
              ),
              const SizedBox(width: 12),
              const Text(
                'Notifikasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            unreadCount > 0
                ? 'Halo ${user.getFirstName()}!\nAnda memiliki $unreadCount notifikasi baru.'
                : 'Halo ${user.getFirstName()}!\nTidak ada notifikasi baru.',
            style: const TextStyle(height: 1.4),
          ),
          actions: [
            if (unreadCount > 0) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showNotificationBottomSheet(context, user);
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6E7E40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Lihat Semua'),
              ),
            ],
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // // Create sample notification (for testing)
  // static void createSampleNotification() {
  //   final notificationService = NotificationService();
  //   final notification = NotificationModel(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     title: 'Notifikasi Test',
  //     message: 'Ini adalah notifikasi test yang dibuat secara dinamis.',
  //     timestamp: DateTime.now(),
  //     type: NotificationType.system,
  //     isRead: false,
  //   );
    
  //   notificationService.addNotification(notification);
  // }
}