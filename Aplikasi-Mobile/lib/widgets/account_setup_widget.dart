import 'package:flutter/material.dart';

/// Widget untuk menampilkan peringatan kelengkapan profil dan UI setup akun
class AccountSetupWidget extends StatelessWidget {
  final String nama;
  final String email;
  final bool isProfileComplete;
  final double profileCompleteness;
  final VoidCallback onNavigateToProfile;

  const AccountSetupWidget({
    super.key, // Pass key directly to the super constructor
    required this.nama,
    required this.email,
    required this.isProfileComplete,
    required this.profileCompleteness,
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    // Jika profil sudah lengkap, tidak tampilkan peringatan
    if (isProfileComplete) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light amber background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFF57C00)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Penyiapan Akun Diperlukan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFF57C00),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Color(0xFFF57C00)),
                onPressed: onNavigateToProfile, // Navigasi ke ProfilePage
                tooltip: 'Lengkapi Profil',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Lengkapi profil Anda untuk mengakses semua fitur KridaSehat.',
            style: TextStyle(color: Color(0xFF8D6E63)),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: profileCompleteness,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6E7E40)),
          ),
          const SizedBox(height: 6),
          Text(
            'Kelengkapan profil: ${(profileCompleteness * 100).toInt()}%',
            style: const TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
          ),
        ],
      ),
    );
  }
}

/// Widget untuk menampilkan tombol lengkapi profil
class CompleteProfileButton extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const CompleteProfileButton({
    super.key, // Pass key directly to the super constructor
    required this.onNavigateToProfile,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.person_add),
      label: const Text('Lengkapi Profil'),
      onPressed: onNavigateToProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Helper class untuk menghitung kelengkapan profil
class ProfileCompletenessHelper {
  /// Menghitung persentase kelengkapan profil untuk progress bar
  static double calculateProfileCompleteness(String nama, String email) {
    int total = 0;
    if (nama.isNotEmpty) total++;
    if (email.isNotEmpty) total++;
    return total / 2; // 2 fields total
  }

  /// Memeriksa apakah profil sudah lengkap
  static bool isProfileComplete(String nama, String email) {
    return nama.isNotEmpty && email.isNotEmpty;
  }
}
