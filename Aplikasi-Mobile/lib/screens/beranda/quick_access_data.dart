import 'package:flutter/material.dart';
import 'data_models.dart';

class QuickAccessData {
  
  static const List<QuickAccessItem> quickAccessItems = [
    QuickAccessItem('Jadwal Hari Ini', Icons.today, Colors.blue),
    QuickAccessItem('Laporan Piket', Icons.assignment, Colors.orange),
    QuickAccessItem('Pengaturan', Icons.settings, Colors.purple),
    QuickAccessItem('Bantuan', Icons.help, Colors.red),
  ];

  static const List<FeatureItem> features = [
    FeatureItem(
      'Pengingat Cerdas',
      'Notifikasi otomatis sebelum waktu piket dimulai',
      Icons.notifications_active,
    ),
    FeatureItem(
      'Laporan Real-time',
      'Pantau kehadiran dan kinerja piket secara langsung',
      Icons.analytics,
    ),
  ];

  static const List<TestimonialData> testimonials = [
    TestimonialData(
      'Sarah Putri',
      'Siswa Kelas XII',
      'PiketKu sangat membantu mengatur jadwal piket di kelas. Sekarang tidak ada lagi yang lupa giliran piket!',
    ),
    TestimonialData(
      'Ahmad Rizki',
      'Ketua OSIS',
      'Aplikasi yang sangat mudah digunakan. Tim kami jadi lebih terorganisir dalam menjalankan tugas sekolah.',
    ),
    TestimonialData(
      'Ibu Sari',
      'Guru Wali Kelas',
      'Sebagai guru, saya merasa sangat terbantu dengan sistem monitoring yang disediakan PiketKu.',
    ),
  ];

  static const List<ActivityData> activities = [
    ActivityData('Kelas 7A', 'Piket sedang berlangsung', '2 menit lalu', true),
    ActivityData('Kelas 8B', 'Piket selesai - Ruangan bersih', '15 menit lalu', false),
    ActivityData('Kelas 9C', 'Menunggu konfirmasi piket', '30 menit lalu', false),
    ActivityData('Kelas 7D', 'Piket terlambat', '45 menit lalu', false),
  ];
}