import 'package:flutter/material.dart';
import 'room_page_pass.dart'; // Import the RoomPagePass class

class RoomPage extends StatefulWidget {
  final String nama;
  final String email;
  final String kelas;

  const RoomPage({
    super.key,
    required this.nama,
    required this.email,
    required this.kelas,
  });

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isRoomLocked = false;

  // Maps untuk menyimpan password room
  final Map<String, String> _roomPasswords = {
    '7A': 'pass7a',
    '7B': '',  // Empty string means no password required
    '8A': 'pass8a',
    '8B': '',
    '9A': 'pass9a',
    '9B': '',
    '9C': 'A',
    '9D': 'A',
  };

  @override
  void initState() {
    super.initState();
    // Cek apakah room terkunci
    _isRoomLocked = _roomPasswords[widget.kelas]?.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPassword() {
    if (_passwordController.text == _roomPasswords[widget.kelas]) {
      // Jika password benar, navigasi ke halaman RoomPagePass
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPagePass(
            nama: widget.nama,
            email: widget.email,
            kelas: widget.kelas,
          ),
        ),
      );
      _passwordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password salah'),
          backgroundColor: Color(0xFFF44336),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color scheme
    const Color primaryColor = Color(0xFF6E7E40);    // Indigo
    const Color accentColor = Color(0xFF4CAF50);     // Green
    const Color bgLightColor = Color(0xFFE8EAF6);    // Light Indigo
    const Color textPrimaryColor = Color(0xFF212121);
    const Color textSecondaryColor = Color(0xFF757575);
    const Color buttonColor = Color(0xFFFF9800);     // Orange
    const Color errorColor = Color(0xFFF44336);      // Red

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsing app bar with background image
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Password button
              if (_isRoomLocked)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: const Icon(Icons.lock, color: Colors.white),
                    tooltip: 'Masukkan password untuk akses penuh',
                    onPressed: () {
                      // Tampilkan dialog password
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Masukkan Password untuk ${widget.kelas}'),
                            content: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password Room',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                prefixIcon: Icon(Icons.lock, color: primaryColor),
                              ),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: textSecondaryColor,
                                ),
                                child: const Text('Batal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _checkPassword();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Verifikasi'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Room Kelas ${widget.kelas}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sora',
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Replace with your actual classroom image
                  Image.network(
                    'https://picsum.photos/800/600?random=1', // Placeholder image
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay in primary color
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withOpacity(0.3),
                          primaryColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Access Notice Banner if room is locked
          if (_isRoomLocked)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: errorColor),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.visibility_off, color: errorColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Mode Terbatas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Anda hanya dapat melihat informasi dasar. Untuk akses penuh dan edit, masukkan password ruangan.',
                      style: TextStyle(color: textSecondaryColor),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.lock_open, color: Colors.white),
                      label: const Text(
                        'Masukkan Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Show password dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Masukkan Password untuk ${widget.kelas}'),
                              content: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password Room',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: primaryColor),
                                ),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: textSecondaryColor,
                                  ),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _checkPassword();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Verifikasi'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          
          // Welcome header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    bgLightColor,
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang di Room ${widget.kelas}!',
                    style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // User information card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: primaryColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Nama: ${widget.nama}', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Sora',
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.email, color: primaryColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Email: ${widget.email}', 
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Sora',
                                    color: textPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.class_, color: primaryColor),
                              const SizedBox(width: 10),
                              Text(
                                'Kelas: ${widget.kelas}', 
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Sora',
                                  color: textPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Information Section Header
                  const Text(
                    'Informasi Kelas:',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                      color: textPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // View-only information
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(Icons.calendar_today, color: accentColor),
                    ),
                    title: Text('Jadwal Piket'),
                    subtitle: Text('Lihat jadwal piket kelas', style: TextStyle(color: textSecondaryColor)),
                    trailing: Icon(Icons.visibility, size: 16, color: primaryColor),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(Icons.photo_library, color: Color(0xFF1976D2)),
                    ),
                    title: Text('Galeri Kebersihan'),
                    subtitle: Text('Lihat foto-foto kebersihan kelas', style: TextStyle(color: textSecondaryColor)),
                    trailing: Icon(Icons.visibility, size: 16, color: primaryColor),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFFFFF3E0),
                      child: Icon(Icons.leaderboard, color: buttonColor),
                    ),
                    title: Text('Peringkat Kelas'),
                    subtitle: Text('Lihat posisi kelas dalam ranking', style: TextStyle(color: textSecondaryColor)),
                    trailing: Icon(Icons.visibility, size: 16, color: primaryColor),
                  ),
                ),
              ),
              
              // Password notice (for locked rooms)
              if (_isRoomLocked)
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: bgLightColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 28,
                        color: primaryColor,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Untuk mengakses fitur edit dan interaksi, masukkan password kelas',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textSecondaryColor),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.vpn_key, color: Colors.white),
                        label: const Text(
                          'Masukkan Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () {
                          // Show password dialog
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Masukkan Password untuk ${widget.kelas}'),
                                content: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    labelText: 'Password Room',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    prefixIcon: Icon(Icons.lock, color: primaryColor),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      foregroundColor: textSecondaryColor,
                                    ),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _checkPassword();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Verifikasi'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              
              // Button at the bottom
              Container(
                margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home, color: Colors.white),
                  label: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }
}

// You need to import RoomPagePass at the top of the file
// import 'room_page_pass.dart';