import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationProvider extends InheritedWidget {
  final NotificationService notificationService;

  const NotificationProvider({
    super.key, // Pass key to the superclass constructor
    required this.notificationService,
    required super.child, // Pass child directly as super parameter
  });

  // Mendapatkan instance NotificationProvider dari context
  static NotificationProvider of(BuildContext context) {
    final NotificationProvider? result =
        context.dependOnInheritedWidgetOfExactType<NotificationProvider>();

    if (result == null) {
      throw FlutterError('NotificationProvider tidak ditemukan dalam konteks yang diberikan');
    }

    return result;
  }

  // Mendapatkan instance NotificationService dari context
  static NotificationService getService(BuildContext context) {
    return of(context).notificationService;
  }

  @override
  bool updateShouldNotify(NotificationProvider oldWidget) {
    return notificationService != oldWidget.notificationService;
  }
}

// Mixin untuk memudahkan akses ke NotificationService
mixin NotificationProviderMixin<T extends StatefulWidget> on State<T> {
  NotificationService get notificationService => NotificationProvider.getService(context);
}
