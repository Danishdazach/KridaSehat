// profile_page.dart
import 'package:flutter/material.dart';
import '../custom/custom_navbar.dart';
import '../custom/custom_sidebar.dart';

class ProfilePage extends StatefulWidget {
  final String initialNama;
  final String initialEmail;
  final Function(String, String) onProfileUpdated;

  const ProfilePage({
  super.key,
  required this.initialNama,
  required this.initialEmail,
  required this.onProfileUpdated,
});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  bool _isEditing = false;
  
  // Tambahkan selected index untuk navigasi
  final int _selectedIndex = 1; // Set ke 1 karena profil biasanya di tab kedua

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.initialNama);
    _emailController = TextEditingController(text: widget.initialEmail);
    // If initial values are empty, start in editing mode automatically
    _isEditing = widget.initialNama.isEmpty || widget.initialEmail.isEmpty;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _simpanIdentitas() {
    final newNama = _namaController.text;
    final newEmail = _emailController.text;
    
    // Call the callback to update the parent widget
    widget.onProfileUpdated(newNama, newEmail);
    
    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Identitas disimpan'),
        backgroundColor: Color(0xFF6E7E40),
      ),
    );
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  // Tambahkan fungsi untuk menangani tap pada navbar
  void _onNavBarTap(int index) {
    // Jika indeks berbeda dari yang dipilih saat ini, navigasikan kembali ke LandingPage
    if (index != _selectedIndex) {
      // Kembali ke LandingPage dan beri tahu untuk memilih tab tertentu
      Navigator.pop(context, index);
    }
  }

  // Fungsi untuk menangani tap pada sidebar
  void _onSidebarItemSelected(int index) {
    _onNavBarTap(index);
  }

  double _calculateProfileCompleteness() {
    int total = 0;
    if (_namaController.text.isNotEmpty) total++;
    if (_emailController.text.isNotEmpty) total++;
    return total / 2; // 2 fields total
  }

  Widget _buildProfileCompletionIndicator() {
    final completeness = _calculateProfileCompleteness();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: completeness,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6E7E40)),
        ),
        const SizedBox(height: 6),
        Text(
          'Kelengkapan profil: ${(completeness * 100).toInt()}%',
          style: const TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Diri',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF6E7E40)),
                    onPressed: _editProfile,
                    tooltip: 'Edit Profil',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isEditing) ...[
              // Edit mode - show text fields
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                onPressed: _simpanIdentitas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6E7E40),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ] else ...[
              // View mode - show info
              ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF6E7E40)),
                title: const Text('Nama'),
                subtitle: Text(
                  _namaController.text.isNotEmpty ? _namaController.text : 'Belum diisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _namaController.text.isEmpty ? Colors.red : null,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.email, color: Color(0xFF6E7E40)),
                title: const Text('Email'),
                subtitle: Text(
                  _emailController.text.isNotEmpty ? _emailController.text : 'Belum diisi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _emailController.text.isEmpty ? Colors.red : null,
                  ),
                ),
              ),
            ],
            
            if (_calculateProfileCompleteness() < 1.0) ...[
              const SizedBox(height: 20),
              _buildProfileCompletionIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Tampilkan notifikasi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru')),
              );
            },
          ),
        ],
      ),
      drawer: CustomSidebar(
        nama: _namaController.text,
        email: _emailController.text,
        selectedIndex: _selectedIndex,
        onItemSelected: _onSidebarItemSelected,
        onProfileUpdate: _editProfile,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header with avatar
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF6E7E40),
                  child: Icon(Icons.person, color: Colors.white, size: 64),
                ),
                const SizedBox(height: 16),
                Text(
                  _namaController.text.isNotEmpty ? _namaController.text : 'Pengguna Baru',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_emailController.text.isNotEmpty)
                  Text(
                    _emailController.text,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Profile Alert for incomplete profiles
          if (_calculateProfileCompleteness() < 1.0)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB74D), width: 1),
              ),
              child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFF57C00)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Profil Belum Lengkap',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF57C00),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Lengkapi profil Anda untuk mengakses semua fitur KridaSehat.',
                  style: TextStyle(color: Color(0xFF8D6E63)),
                ),
              ],
            ),
            ),
          
          // Profile form (edit/view mode)
          _buildProfileForm(),
          
          // Additional sections could be added here
          const SizedBox(height: 16),
        ],
      ),
      // Tambahkan bottomNavigationBar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: const Color(0xFF6E7E40),
        // Berikan data yang diperlukan untuk navigasi
        nama: _namaController.text,
        email: _emailController.text,
        onProfileUpdated: widget.onProfileUpdated,
      ),
    );
  }
}

// Dialog helper function that can be called from any page
void showEditProfileDialog(
  BuildContext context, 
  String currentNama, 
  String currentEmail,
  Function(String, String) onProfileUpdated
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final TextEditingController tempNamaController = TextEditingController(text: currentNama);
      final TextEditingController tempEmailController = TextEditingController(text: currentEmail);
      
      return AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tempNamaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: tempEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onProfileUpdated(tempNamaController.text, tempEmailController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
} 