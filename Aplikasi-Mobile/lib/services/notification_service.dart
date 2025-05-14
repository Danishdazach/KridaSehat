import 'package:flutter/material.dart';
import 'dart:async';

// Import widget notifikasi
import '../widgets/notification_widget.dart';

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  
  // Getter untuk instance
  static NotificationService get instance => _instance;

  // Constructor factory
  factory NotificationService() {
    return _instance;
  }

  // Private constructor
  NotificationService._internal();

  // Stream controller untuk notifikasi
  final StreamController<int> _notificationController = StreamController<int>.broadcast();
  
  // Jumlah notifikasi yang belum dibaca
  int _unreadCount = 0;

  // Stream untuk memantau perubahan jumlah notifikasi
  Stream<int> get notificationStream => _notificationController.stream;

  // Getter untuk jumlah notifikasi yang belum dibaca
  int get unreadCount => _unreadCount;

  // Daftar notifikasi yang disimpan dalam memory
  final List<NotificationItem> _notifications = [];

  // Inisialisasi service
  void init() {
    // Contoh notifikasi untuk testing
    _addSampleNotifications();
  }

  // Tambahkan contoh notifikasi
  void _addSampleNotifications() {
    addNotification(
      title: 'Selamat datang di KridaSehat!',
      message: 'Terima kasih telah bergabung dengan KridaSehat. Lengkapi profil Anda untuk pengalaman yang lebih baik.',
      type: NotificationType.welcome,
    );
    
    addNotification(
      title: 'Pengingat Kesehatan',
      message: 'Jangan lupa untuk mengisi catatan kesehatan harian Anda hari ini.',
      type: NotificationType.reminder,
    );
  }

  // Tambahkan notifikasi baru
  void addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    bool isRead = false,
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      isRead: isRead,
    );

    _notifications.add(notification);
    
    if (!isRead) {
      _unreadCount++;
      _notificationController.add(_unreadCount);
    }
  }

  // Dapatkan semua notifikasi
  List<NotificationItem> getNotifications() {
    return List.from(_notifications);
  }

  // Perbarui jumlah notifikasi yang belum dibaca
  void updateUnreadCount(int count) {
    _unreadCount = count;
    _notificationController.add(_unreadCount);
  }

  // Tandai notifikasi sebagai telah dibaca
  void markAsRead(String id) {
    for (var notification in _notifications) {
      if (notification.id == id && !notification.isRead) {
        notification.isRead = true;
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        _notificationController.add(_unreadCount);
        break;
      }
    }
  }

  // Tandai semua notifikasi sebagai telah dibaca
  void markAllAsRead() {
    bool hasUnread = false;
    
    for (var notification in _notifications) {
      if (!notification.isRead) {
        notification.isRead = true;
        hasUnread = true;
      }
    }
    
    if (hasUnread) {
      _unreadCount = 0;
      _notificationController.add(_unreadCount);
    }
  }

  // Hapus notifikasi
  void deleteNotification(String id) {
    final notification = _notifications.firstWhere(
      (notification) => notification.id == id,
      orElse: () => NotificationItem(
        id: '',
        title: '',
        message: '',
        type: NotificationType.info,
        timestamp: DateTime.now(),
        isRead: true,
      ),
    );
    
    if (notification.id.isNotEmpty) {
      _notifications.removeWhere((n) => n.id == id);
      
      if (!notification.isRead) {
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        _notificationController.add(_unreadCount);
      }
    }
  }

  // Tampilkan panel notifikasi
  void showNotificationPanel(BuildContext context) {
    NotificationHelper.showNotificationPanel(
      context,
      onNotificationUpdate: updateUnreadCount,
      unreadCount: _unreadCount,
    );
  }

  // Dispose service
  void dispose() {
    _notificationController.close();
  }
}