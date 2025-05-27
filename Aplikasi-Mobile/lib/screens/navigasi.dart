import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'kuis/kuis_page.dart';
import 'leaderboard_page.dart';
import 'shop_page.dart';
import 'kelas/kelas_page.dart';
import 'custom_app_bar.dart';
import '../widgets/sidebar.dart'; // Import sidebar baru
import '../models/user_model.dart';
import '../services/notification_service.dart';
import '../widgets/notification_widgets.dart';
import '../widgets/app_theme.dart';

class NavigasiPage extends StatefulWidget {
  const NavigasiPage({super.key});

  @override
  State<NavigasiPage> createState() => _NavigasiPageState();
}

class _NavigasiPageState extends State<NavigasiPage> {
  int _selectedIndex = 0;
  
  // Inisialisasi langsung, bukan late
  final NotificationService _notificationService = NotificationService();
  late final UserModel _currentUser;
  
  // List judul halaman
  final List<String> _pageTitles = [
    'Beranda',
    'Kuis Cepat',
    'Kelas',
    'Peringkat',
    'Penukaran',
  ];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    // Inisialisasi user dengan try-catch untuk menangani error
    try {
      _currentUser = UserModel(
        id: '1',
        name: 'Danish Zaki Chamidy',
        email: 'Danish@email.com',
        level: 1,
        totalQuizzes: 15,
        points: 500,
        grade: 7,
        school: 'SMP Negeri 5 Malng',
        profileImageUrl: null,
      );
      
      // Initialize notifications
      _notificationService.initializeSampleData(_currentUser);
    } catch (e) {
      debugPrint('Error initializing user: $e');
      // Handle error gracefully
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNotificationTap() {
    try {
      NotificationHelper.showNotificationBottomSheet(context, _currentUser);
    } catch (e) {
      debugPrint('Error showing notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal membuka notifikasi'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  // Method untuk membuat halaman on-demand
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return LandingPage();
      case 1:
        return const KuisPage();
      case 2:
        return const KelasPage();
      case 3:
        return const LeaderboardPage();
      case 4:
        return const ShopPage();
      default:
        return LandingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, // Background hijau lembut
      appBar: CustomAppBar(
        title: _pageTitles[_selectedIndex],
        user: _currentUser,
        onNotificationTap: _onNotificationTap,
        layout: _getAppBarLayout(),
      ),
      // Menggunakan ProfileSidebar yang terpisah
      drawer: ProfileSidebar(
        user: _currentUser,
        notificationService: _notificationService,
        onNotificationTap: _onNotificationTap,
      ),
      body: _buildPage(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBarLayout _getAppBarLayout() {
    switch (_selectedIndex) {
      case 0:
        return AppBarLayout.detailed;
      default:
        return AppBarLayout.compact;
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // Hijau gelap konsisten dengan AppBar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Beranda',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.flash_on_rounded,
                label: 'Cepat',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.inventory_2_rounded,
                label: 'Kelas',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Peringkat',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.swap_horiz_rounded,
                label: 'Penukaran',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget? _buildFloatingActionButton() {
  //   if (_selectedIndex != 0) return null;
    
  //   return FloatingActionButton.small(
  //     onPressed: () {
  //       try {
  //         NotificationHelper.createSampleNotification();
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: const Text('Notifikasi test dibuat! 🔔'),
  //             backgroundColor: AppTheme.secondaryColor,
  //             duration: const Duration(seconds: 2),
  //             behavior: SnackBarBehavior.floating,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //         );
  //       } catch (e) {
  //         debugPrint('Error creating notification: $e');
  //       }
  //     },
  //     backgroundColor: AppTheme.secondaryColor, // Hijau cerah untuk konsistensi
  //     elevation: 3,
  //     child: const Icon(Icons.add_alert_rounded, color: Colors.white),
  //   );
  // }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color selectedColor = Colors.white;
    final Color unselectedColor = Colors.white.withOpacity(0.7);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Icon(
                    icon,
                    color: isSelected ? selectedColor : unselectedColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}