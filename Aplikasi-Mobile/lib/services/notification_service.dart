import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Model untuk notifikasi
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    }
  }
}

enum NotificationType {
  quiz,
  achievement,
  reminder,
  system,
  social,
}

// Service untuk mengelola notifikasi
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<NotificationModel> _notifications = [];
  final List<VoidCallback> _listeners = [];

  // Getter untuk notifications
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  bool get hasUnreadNotifications => unreadCount > 0;

  // Subscribe to changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Initialize dengan sample data
  void initializeSampleData(UserModel user) {
    _notifications.clear();
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Kuis Baru Tersedia!',
        message: 'Kuis Matematika untuk kelas ${user.grade} sudah tersedia. Yuk, test kemampuanmu!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        type: NotificationType.quiz,
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: '🎉 Achievement Unlocked!',
        message: 'Selamat! Kamu berhasil menyelesaikan 10 kuis berturut-turut.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.achievement,
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Reminder: Kuis Harian',
        message: 'Jangan lupa mengerjakan kuis harian untuk mempertahankan streak!',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.reminder,
        isRead: true,
      ),
      // NotificationModel(
      //   id: '4',
      //   title: 'Update Aplikasi',
      //   message: 'Fitur baru telah ditambahkan! Update aplikasi untuk pengalaman yang lebih baik.',
      //   timestamp: DateTime.now().subtract(const Duration(days: 1)),
      //   type: NotificationType.system,
      //   isRead: false,
      // ),
      // NotificationModel(
      //   id: '5',
      //   title: 'Teman Baru!',
      //   message: 'Alex menambahkan kamu sebagai teman. Tantang dia untuk kuis!',
      //   timestamp: DateTime.now().subtract(const Duration(days: 2)),
      //   type: NotificationType.social,
      //   isRead: true,
      // ),
    ]);
    _notifyListeners();
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _notifyListeners();
  }

  // Add new notification
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _notifyListeners();
  }

  // Remove notification
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _notifyListeners();
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    _notifyListeners();
  }

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }
}

// Extension untuk NotificationType
extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.quiz:
        return Icons.quiz;
      case NotificationType.achievement:
        return Icons.star;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.system:
        return Icons.system_update;
      case NotificationType.social:
        return Icons.people;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.quiz:
        return Colors.blue;
      case NotificationType.achievement:
        return Colors.amber;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.social:
        return Colors.green;
    }
  }

  String get displayName {
    switch (this) {
      case NotificationType.quiz:
        return 'Kuis';
      case NotificationType.achievement:
        return 'Pencapaian';
      case NotificationType.reminder:
        return 'Pengingat';
      case NotificationType.system:
        return 'Sistem';
      case NotificationType.social:
        return 'Sosial';
    }
  }
}