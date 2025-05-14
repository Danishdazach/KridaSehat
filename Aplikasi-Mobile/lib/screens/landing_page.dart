import 'package:flutter/material.dart';
// Import halaman profil pengguna untuk navigasi dan pengelolaan data profil
import 'profile_page.dart';
// Import komponen kustom untuk tampilan navigasi bawah
import '../custom/custom_navbar.dart';
// Import komponen kustom untuk menu samping (drawer)
import '../custom/custom_sidebar.dart';
// Import halaman detail profil sekolah
import 'school_profile_page.dart';
// Import widget setup akun
import '../widgets/account_setup_widget.dart';
// Import widget setup sekolah
import '../widgets/school_setup_widget.dart';

// Import Service dan Widget Notifikasi
import '../services/notification_service.dart';
import '../widgets/notification_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Indeks untuk navigasi antar halaman
  int _selectedIndex = 0;

  // Data profil pengguna yang akan diupdate dari ProfilePage
  String _nama = '';
  String _email = '';
  bool _isProfileComplete = false;
  
  // Data sekolah yang telah ditambahkan
  final List<Map<String, dynamic>> _schools = [];
  
  // Jumlah notifikasi yang belum dibaca
  int _unreadNotifications = 0;
  
  @override
  void initState() {
    super.initState();
    // Cek apakah profil pengguna sudah lengkap
    _checkProfileCompletion();
    
    // Inisialisasi layanan notifikasi
    _initializeNotificationService();
  }
  
  void _initializeNotificationService() {
    // Inisialisasi notifikasi service
    NotificationService.instance.init();
    
    // Berlangganan perubahan jumlah notifikasi
    NotificationService.instance.notificationStream.listen((count) {
      setState(() {
        _unreadNotifications = count;
      });
    });
    
    // Dapatkan jumlah notifikasi saat ini
    _unreadNotifications = NotificationService.instance.unreadCount;
  }

  // Fungsi untuk memeriksa kelengkapan profil pengguna
  void _checkProfileCompletion() {
    setState(() {
      _isProfileComplete = ProfileCompletenessHelper.isProfileComplete(_nama, _email);
    });
  }

  // Fungsi yang dipanggil oleh CustomBottomNavBar untuk perpindahan halaman
  void _onItemTapped(int index) {
    // Make sure index is within valid range
    if (index >= 0 && index < _pages.length) {
      setState(() => _selectedIndex = index);
    }
  }

  // Fungsi yang dipanggil oleh ProfilePage ketika profil diperbarui
  void _updateProfile(String nama, String email) {
    setState(() {
      _nama = nama;
      _email = email;
      _checkProfileCompletion();
    });
  }

  // Navigasi ke halaman profil dengan membawa data profil saat ini
  // dan callback untuk update profil
  void _navigateToProfilePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          initialNama: _nama,
          initialEmail: _email,
          onProfileUpdated: _updateProfile, // Callback untuk update profil
        ),
      ),
    );
    
    // Jika result berisi index, update _selectedIndex
    if (result != null && result is int) {
      setState(() {
        _selectedIndex = result;
      });
    }
  }

  // Navigasi ke halaman profil sekolah dengan membawa data sekolah dan profil pengguna
  void _navigateToSchoolProfilePage(Map<String, dynamic> school) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchoolProfilePage(
          school: school,
          nama: _nama,
          email: _email,
        ),
      ),
    );
    
    // Jika result berisi index, update _selectedIndex
    if (result != null && result is int) {
      setState(() {
        _selectedIndex = result;
      });
    }
  }

  // Fungsi untuk menampilkan panel notifikasi
  void _showNotificationPanel() {
    NotificationService.instance.showNotificationPanel(context);
  }

  void _addSchool(String name, String address) {
    setState(() {
      _schools.add({
        'name': name,
        'address': address,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'joinCode': _generateJoinCode(),
        'members': 1,
      });
      
      // Tambahkan notifikasi saat sekolah berhasil ditambahkan
      NotificationService.instance.addNotification(
        title: 'Sekolah Ditambahkan',
        message: 'Sekolah $name berhasil ditambahkan ke daftar sekolah Anda.',
        type: NotificationType.info,
      );
    });
  }
  
  // Bergabung dengan sekolah menggunakan kode
  void _joinSchoolWithCode(String joinCode) {
    bool foundSchool = false;
    String schoolName = '';
    
    setState(() {
      for (var school in _schools) {
        if (school['joinCode'] == joinCode) {
          school['members'] = (school['members'] ?? 0) + 1;
          foundSchool = true;
          schoolName = school['name'];
          break;
        }
      }
    });
    
    if (foundSchool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil bergabung dengan sekolah!')),
      );
      
      // Tambahkan notifikasi saat berhasil bergabung dengan sekolah
      NotificationService.instance.addNotification(
        title: 'Bergabung dengan Sekolah',
        message: 'Anda berhasil bergabung dengan sekolah $schoolName.',
        type: NotificationType.welcome,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode join tidak valid. Silakan coba lagi.')),
      );
    }
  }
  
  // Generate kode join acak untuk sekolah
  String _generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = DateTime.now().millisecondsSinceEpoch % 1000000;
    String result = '';
    
    for (var i = 0; i < 6; i++) {
      result += chars[(rnd + i) % chars.length];
    }
    
    return result;
  }

  void _showAddSchoolDialog() {
    SchoolDialogHelper.showAddSchoolDialog(context, _addSchool);
  }

  void _showJoinWithCodeDialog() {
    SchoolDialogHelper.showJoinWithCodeDialog(context, _joinSchoolWithCode);
  }

  Widget _buildSchoolCard(Map<String, dynamic> school) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () => _navigateToSchoolProfilePage(school),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6E7E40).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF6E7E40)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          school['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          school['address'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${school['members']} anggota',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Kode Join:',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Copy to clipboard
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Kode ${school['joinCode']} disalin ke clipboard')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6E7E40).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(
                                school['joinCode'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Color(0xFF6E7E40),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.copy, size: 12, color: Color(0xFF6E7E40)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchoolsList() {
    if (_schools.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada sekolah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan sekolah baru atau bergabung dengan kode',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _schools.length,
      itemBuilder: (context, index) {
        return _buildSchoolCard(_schools[index]);
      },
    );
  }

  // Widget untuk halaman beranda, tab pertama pada bottom navigation
  Widget _buildBeranda() {
    // Menghitung kelengkapan profil
    final double profileCompleteness = ProfileCompletenessHelper.calculateProfileCompleteness(_nama, _email);
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Welcome card at the top
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFF6E7E40),
                      child: Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang${_nama.isNotEmpty ? ', $_nama' : ''}!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Semangat belajar hari ini',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Account Setup Alert - Menggunakan widget dari file terpisah
        AccountSetupWidget(
          nama: _nama,
          email: _email,
          isProfileComplete: _isProfileComplete,
          profileCompleteness: profileCompleteness,
          onNavigateToProfile: _navigateToProfilePage,
        ),
        
        // School Setup Alert - Menggunakan widget dari file terpisah
        SchoolSetupWidget(
          onAddSchool: _showAddSchoolDialog,
          onJoinWithCode: _showJoinWithCodeDialog,
        ),
        
        // Complete Profile Button (if profile is incomplete) - Menggunakan widget dari file terpisah
        if (!_isProfileComplete)
          CompleteProfileButton(
            onNavigateToProfile: _navigateToProfilePage,
          ),
        
        const SizedBox(height: 16),
        
        // Schools List Section
        const Text(
          'Sekolah Saya',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6E7E40)),
        ),
        const SizedBox(height: 8),
        _buildSchoolsList(),
        
        const SizedBox(height: 24),
      ],
    );
  }

  // Widget untuk tab profil pada bottom navigation
  Widget _buildProfil() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xFF6E7E40),
            child: Icon(Icons.person, color: Colors.white, size: 60),
          ),
          const SizedBox(height: 24),
          Text(
            _nama.isNotEmpty ? _nama : 'Pengguna Baru',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_email.isNotEmpty)
            Text(
              _email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Kelola Profil'),
            onPressed: _navigateToProfilePage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E7E40),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk tab pengaturan pada bottom navigation
  Widget _buildPengaturan() {
    return const Center(child: Text('Pengaturan', style: TextStyle(fontSize: 24)));
  }

  // Daftar halaman yang tersedia dalam aplikasi untuk navigasi bottom bar
  // PENTING: Jumlah item harus sesuai dengan jumlah item di bottom navigation bar
  List<Widget> get _pages => <Widget>[
    _buildBeranda(),
    _buildProfil(),
    _buildPengaturan(),
    const Center(child: Text('Tentang', style: TextStyle(fontSize: 24))), // Halaman baru untuk tab 'Tentang'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hapus title KridaSehat
        backgroundColor: const Color(0xFF6E7E40),
        foregroundColor: Colors.white,
        leadingWidth: 24, // Kurangi lebar leading untuk space yang lebih baik
        // Pindahkan profil ke title (bagian utama) bukan di actions
        title: InkWell(
          onTap: _navigateToProfilePage,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF6E7E40), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nama.isNotEmpty ? _nama : 'Pengguna',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email.isNotEmpty ? _email : 'Selamat datang',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          // Tombol notifikasi dengan badge
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 26),
                  onPressed: _showNotificationPanel,
                ),
                if (_unreadNotifications > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: NotificationBadge(count: _unreadNotifications),
                  ),
              ],
            ),
          ),
        ],
      ),
      // Menggunakan CustomSidebar dari file custom_sidebar.dart
      drawer: CustomSidebar(
        nama: _nama, // Mengirim data nama ke sidebar
        email: _email, // Mengirim data email ke sidebar
        selectedIndex: _selectedIndex, // Mengirim indeks halaman aktif
        onItemSelected: _onItemTapped, // Callback untuk navigasi
        onProfileUpdate: _navigateToProfilePage, // Callback untuk update profil
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Menggunakan CustomBottomNavBar dari file custom_navbar.dart
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex, // Indeks tab yang aktif
        onTap: _onItemTapped, // Callback untuk perpindahan tab
        selectedItemColor: const Color(0xFF6E7E40), // Warna tab yang aktif
        // Data yang diperlukan untuk komponen CustomBottomNavBar
        nama: _nama,
        email: _email,
        onProfileUpdated: _updateProfile, // Callback untuk update profil dari CustomBottomNavBar
      ),
    );
  }
}