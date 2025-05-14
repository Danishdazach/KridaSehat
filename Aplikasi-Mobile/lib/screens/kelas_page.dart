import 'package:flutter/material.dart';
import 'room_page.dart';

class KelasPage extends StatefulWidget {
  final String tingkat;
  final String nama;
  final String email;

  const KelasPage({
    super.key,
    required this.tingkat,
    required this.nama,
    required this.email,
  });

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  // Constants
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color bgLightColor = Color(0xFFE8EAF6);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color buttonColor = Color(0xFFFF9800);

  // Data structure
  final Map<String, List<String>> _kelasPerTingkat = {
    '7': ['7A', '7B'],
    '8': ['8A', '8B'],
    '9': ['9A', '9B', '9C', '9D'],
  };

  final Map<String, String> _kelasImages = {
    '7A': 'assets/board/board2.png',
    '7B': 'assets/images/kelas_7b.png',
    '8A': 'assets/images/kelas_8a.png',
    '8B': 'assets/images/kelas_8b.png',
    '9A': 'assets/images/kelas_9a.png',
    '9B': 'assets/images/kelas_9b.png',
    '9C': 'assets/images/kelas_9c.png',
    '9D': 'assets/images/kelas_9d.png',
  };

  // Maps for class styling
  final Map<String, ClassStyle> _classStyles = {
    'A': ClassStyle(
      backgroundColor: const Color(0xFFE3F2FD),
      iconColor: const Color(0xFF1976D2),
      icon: Icons.school,
    ),
    'B': ClassStyle(
      backgroundColor: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF388E3C),
      icon: Icons.school_outlined,
    ),
    'C': ClassStyle(
      backgroundColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
      icon: Icons.auto_stories,
    ),
    'D': ClassStyle(
      backgroundColor: const Color(0xFFE1F5FE),
      iconColor: const Color(0xFF00BCD4),
      icon: Icons.menu_book,
    ),
  };

  // Default style for classes without specific styles
  final ClassStyle _defaultStyle = ClassStyle(
    backgroundColor: const Color(0xFFE0F2F1),
    iconColor: const Color(0xFF009688),
    icon: Icons.science,
  );

  void _navigateToRoom(String room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomPage(
          nama: widget.nama,
          email: widget.email,
          kelas: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> kelasList = _kelasPerTingkat[widget.tingkat] ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildHeaderContent(),
          _buildClassesGrid(kelasList),
        ],
      ),
    );
  }

  // AppBar with header image
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Kelas ${widget.tingkat}',
          style: const TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://picsum.photos/800/600',
              fit: BoxFit.cover,
            ),
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
            Positioned(
              top: 50,
              left: 20,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/school_logo.png',
                  width: 45,
                  height: 45,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.school,
                    size: 30,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header content section
  Widget _buildHeaderContent() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              bgLightColor,
              Color(0xFFE8EAF6),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Kelas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sora',
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan pilih kelas yang ingin Anda masuki',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sora',
                  color: textSecondaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Warning banner when user info is incomplete
              if (widget.nama.isEmpty || widget.email.isEmpty)
                _buildWarningBanner(),
            ],
          ),
        ),
      ),
    );
  }

  // Warning banner for incomplete user info
  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: buttonColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: buttonColor),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: buttonColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Perhatian: Identitas Anda belum lengkap! Harap isi nama dan email di halaman Beranda.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
                color: buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Grid of classes
  Widget _buildClassesGrid(List<String> kelasList) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final kelas = kelasList[index];
            return _buildClassCard(kelas);
          },
          childCount: kelasList.length,
        ),
      ),
    );
  }

  // Individual class card
  Widget _buildClassCard(String kelas) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToRoom(kelas),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Class image/logo
            Expanded(
              flex: 7,
              child: _getClassImage(kelas),
            ),
            // Class name section
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kelas,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sora',
                        color: textPrimaryColor,
                      ),
                    ),
                    const Text(
                      'Masuk ke kelas',
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get class image or fallback
  Widget _getClassImage(String kelas) {
    // Coba mendapatkan gambar dari assets jika tersedia
    if (_kelasImages.containsKey(kelas)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          _kelasImages[kelas]!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120,
          errorBuilder: (context, error, stackTrace) => _buildFallbackImage(kelas),
        ),
      );
    } else {
      // Jika tidak ada gambar, gunakan fallback
      return _buildFallbackImage(kelas);
    }
  }

  // Fallback image for classes without images
  Widget _buildFallbackImage(String kelas) {
    final String classLetter = kelas.substring(kelas.length - 1);
    final ClassStyle style = _classStyles[classLetter] ?? _defaultStyle;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                style.icon,
                size: 50,
                color: style.iconColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Kelas $kelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: style.iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}

// Helper class for styling class cards
class ClassStyle {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  ClassStyle({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });
}