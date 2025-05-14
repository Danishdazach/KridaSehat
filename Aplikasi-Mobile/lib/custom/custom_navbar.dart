// custom_navbar.dart
import 'package:flutter/material.dart';
import '../screens/profile_page.dart'; // Import file yang diperlukan

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color selectedItemColor;
  final String? nama;       // Data untuk profile_page
  final String? email;      // Data untuk profile_page
  final Function(String, String)? onProfileUpdated; // Callback untuk update profile

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.selectedItemColor,
    this.nama,
    this.email,
    this.onProfileUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // The main navigation bar
        Container(
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFFF7700),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home, 'Beranda'),
              _buildNavItem(context, 1, Icons.bolt, 'Cepat'),
              // Empty space for the center button
              const SizedBox(width: 60),
              _buildNavItem(context, 2, Icons.bar_chart, 'Peringkat'),
              _buildNavItem(context, 3, Icons.swap_horiz, 'Penukaran'),
            ],
          ),
        ),
        
        // The floating center button
        Positioned(
          top: -25,
          child: GestureDetector(
            onTap: () {
              _showMainMenu(context);
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7700),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: Color(0xFFFF7700),
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final bool isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        // Handle navigation based on index
        switch (index) {
          case 0: // Beranda
            onTap(index);
            break;
          case 1: // Cepat - Navigate to ProfilePage
            _navigateToProfilePage(context);
            break;
          case 2: // Peringkat
            onTap(index);
            break;
          case 3: // Penukaran
            onTap(index);
            break;
          default:
            onTap(index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigasi ke ProfilePage
  void _navigateToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          initialNama: nama ?? '',
          initialEmail: email ?? '',
          onProfileUpdated: onProfileUpdated ?? ((_, __) {}),
        ),
      ),
    );
  }

  // Tampilkan menu utama saat tombol tengah ditekan
  void _showMainMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menu Utama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              onTap: () {
                Navigator.pop(context);
                _navigateToProfilePage(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Sekolah'),
              onTap: () {
                Navigator.pop(context);
                // Navigasi ke halaman sekolah (bisa ditambahkan nanti)
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                onTap(2); // Navigasi ke tab Pengaturan
              },
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

  // Static list of navigation items to be accessible from outside
  static List<Map<String, dynamic>> get navigationItems => [
    {'icon': Icons.home, 'label': 'Beranda'},
    {'icon': Icons.bolt, 'label': 'Cepat'},
    {'icon': Icons.bar_chart, 'label': 'Peringkat'},
    {'icon': Icons.swap_horiz, 'label': 'Penukaran'},
  ];
  
  // Helper method to get the number of navigation items
  static int get itemCount => 4; // Update this if you change the number of items
}