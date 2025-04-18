import 'package:flutter/material.dart';
import 'kelas_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  String _nama = '';
  String _email = '';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Daftar tingkat kelas yang tersedia
  final List<String> _tingkatKelas = ['7', '8', '9'];

  @override
  void dispose() {
    _pageController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _simpanIdentitas() {
    setState(() {
      _nama = _namaController.text;
      _email = _emailController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Identitas disimpan')),
    );
  }

  void _navigateToKelasPage(String tingkat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KelasPage(
          tingkat: tingkat,
          nama: _nama,
          email: _email,
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
              Icon(
                Icons.school,
                size: 64,
                color: Theme.of(context).primaryColor,
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
                'Lihat semua kelas $tingkat',
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

  Widget _buildBeranda() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Simpan Identitas'),
            onPressed: _simpanIdentitas,
          ),
          const Divider(height: 32),
          const Text(
            'Pilih Tingkat Kelas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PageView(
              controller: _pageController,
              children: _tingkatKelas.map((tingkat) => _buildKelasCard(tingkat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _pages => <Widget>[
        _buildBeranda(),
        Center(child: Text('Profil: $_nama', style: const TextStyle(fontSize: 24))),
        const Center(child: Text('Pengaturan', style: TextStyle(fontSize: 24))),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Landing Page')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 35),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nama.isNotEmpty ? _nama : 'Nama belum diisi',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    _email.isNotEmpty ? _email : 'Email belum diisi',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
