import 'package:flutter/material.dart';

class QuickAccessItem {
  final String title;
  final IconData icon;
  final Color color;

  const QuickAccessItem(this.title, this.icon, this.color);
}

class FeatureItem {
  final String title;
  final String description;
  final IconData icon;

  const FeatureItem(this.title, this.description, this.icon);
}

class TestimonialData {
  final String name;
  final String role;
  final String message;

  const TestimonialData(this.name, this.role, this.message);
}

class ActivityData {
  final String className;
  final String activity;
  final String timestamp;
  final bool isActive;

  const ActivityData(this.className, this.activity, this.timestamp, this.isActive);
}