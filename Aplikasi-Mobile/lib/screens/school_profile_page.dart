import 'package:flutter/material.dart';
import 'kelas_page.dart';

class SchoolProfilePage extends StatefulWidget {
  final Map<String, dynamic> school;
  final String nama;
  final String email;

  const SchoolProfilePage({
    super.key,  // Use `super.key` directly here to pass the key to the superclass
    required this.school,
    required this.nama,
    required this.email,
  });

  @override
  State<SchoolProfilePage> createState() => _SchoolProfilePageState();
}

class _SchoolProfilePageState extends State<SchoolProfilePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Daftar tingkat kelas yang tersedia
  final List<String> _tingkatKelas = ['7', '8', '9'];

  // Dummy data untuk leaderboard
  final List<Map<String, dynamic>> _leaderboardData = [
    {'name': 'Ahmad S.', 'points': 350, 'rank': 1, 'avatar': 'A'},
    {'name': 'Budi Santoso', 'points': 320, 'rank': 2, 'avatar': 'B'},
    {'name': 'Citra Dewi', 'points': 285, 'rank': 3, 'avatar': 'C'},
    {'name': 'Dian Pratama', 'points': 250, 'rank': 4, 'avatar': 'D'},
    {'name': 'Eko Wibowo', 'points': 230, 'rank': 5, 'avatar': 'E'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToKelasPage(String tingkat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KelasPage(
          tingkat: tingkat,
          nama: widget.nama,
          email: widget.email,
        ),
      ),
    );
  }

  Widget _buildKelasCard(String tingkat) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _navigateToKelasPage(tingkat),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                size: 64,
                color: Color(0xFF6E7E40),
              ),
              const SizedBox(height: 16),
              Text(
                'Kelas $tingkat',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lihat materi pembelajaran',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> data, bool isTopThree) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isTopThree ? const Color(0xFFF0F4E3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isTopThree ? const Color(0xFF6E7E40) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${data['rank']}',
              style: TextStyle(
                color: isTopThree ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              data['avatar'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            '${data['points']} poin',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6E7E40),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.school['name'] ?? 'Profil Sekolah'),
        backgroundColor: const Color(0xFF6E7E40),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with school info
            Container(
              width: double.infinity,
              color: const Color(0xFF6E7E40),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          size: 50,
                          color: Color(0xFF6E7E40),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.school['name'] ?? 'Nama Sekolah',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.school['address'] ?? 'Alamat Sekolah',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Informasi Sekolah
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Sekolah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'Kepala Sekolah',
                          widget.school['principal'] ?? 'Nama Kepala Sekolah',
                          Icons.person,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Telepon',
                          widget.school['phone'] ?? '(021) 1234-5678',
                          Icons.phone,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Email',
                          widget.school['email'] ?? 'email@sekolah.edu',
                          Icons.email,
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Akreditasi',
                          widget.school['accreditation'] ?? 'A',
                          Icons.verified,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Pilihan Kelas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Kelas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _tingkatKelas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _buildKelasCard(_tingkatKelas[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Leaderboard
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Papan Peringkat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(_leaderboardData.length, (index) {
                      final data = _leaderboardData[index];
                      return _buildLeaderboardItem(data, index < 3);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6E7E40),
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
