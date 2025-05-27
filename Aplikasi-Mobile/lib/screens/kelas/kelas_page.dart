import 'package:flutter/material.dart';
import '1beranda_tab.dart';
import '2anggota_tab.dart';
import '3galeri_tab.dart';
import 'pengaturan/pengaturan_kelas.dart';  // Import halaman pengaturan kelas
// Import the models from class_management.dart instead of defining them here
import '../beranda/class_management.dart';
import '../../widgets/app_theme.dart';

class KelasPage extends StatefulWidget {
  // Parameter yang diterima dari ClassSelectionPage
  final String? selectedClass;
  final String? selectedGrade;
  final ClassInfo? classInfo;
  final Teacher? teacher;

  const KelasPage({
    super.key,
    this.selectedClass,
    this.selectedGrade,
    this.classInfo,
    this.teacher,
  });

  @override
  KelasPageState createState() => KelasPageState();
}

class KelasPageState extends State<KelasPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Design System Constants
  static const double _borderRadius = 16.0;
  static const double _cardPadding = 16.0;
  static const double _spacing = 16.0;
  static const double _smallSpacing = 8.0;
  static const double _largeSpacing = 24.0;
  static const double _iconSize = 20.0;
  
  // Informasi kelas - dinamis berdasarkan data yang diterima
  late String namaKelas;
  late String waliKelas;
  
  // Data anggota kelas (contoh static - bisa disesuaikan dengan data real)
  final List<Map<String, dynamic>> anggotaKelas = [
  {"nama": "Achmad Faruq Al Farizi", "nisn": "1001", "jabatan": "Ketua Kelas"},
  {"nama": "Achmad Kibi", "nisn": "1002", "jabatan": "Wakil Ketua"},
  {"nama": "Adli Azzamy Syauqi", "nisn": "1003", "jabatan": "Sekretaris"},
  {"nama": "Aisyah Naylaturrohmah", "nisn": "1004", "jabatan": "Bendahara"},
  {"nama": "Allysa Selvira Probokusumo", "nisn": "1005", "jabatan": "Anggota"},
  {"nama": "Amanda Budiyono", "nisn": "1006", "jabatan": "Anggota"},
  {"nama": "Amanda Salsabila Azzahra", "nisn": "1007", "jabatan": "Anggota"},
  {"nama": "Avrillya Rana Zahabiyya", "nisn": "1008", "jabatan": "Anggota"},
  {"nama": "Cahaya Putri Harimurti", "nisn": "1009", "jabatan": "Anggota"},
  {"nama": "Dinar Divianingrum Febriana", "nisn": "1010", "jabatan": "Anggota"},
  {"nama": "Fabriano Asyraafi Subagja", "nisn": "1011", "jabatan": "Anggota"},
  {"nama": "Farrah Avrilia Putri Prasetya", "nisn": "1012", "jabatan": "Anggota"},
  {"nama": "Fayyaza Maisa Nawra Arya", "nisn": "1013", "jabatan": "Anggota"},
  {"nama": "Felisha Vania Nazila", "nisn": "1014", "jabatan": "Anggota"},
  {"nama": "Fergie Salsabillah Ferianputri", "nisn": "1015", "jabatan": "Anggota"},
  {"nama": "Galuh Dyah Palupi", "nisn": "1016", "jabatan": "Anggota"},
  {"nama": "Kayla Fadia Haya", "nisn": "1017", "jabatan": "Anggota"},
  {"nama": "Levina Fajriyah", "nisn": "1018", "jabatan": "Anggota"},
  {"nama": "Lintang Kirana Ardhana Aryabhumi", "nisn": "1019", "jabatan": "Anggota"},
  {"nama": "Mohammad Goldy Rayshafa Firnanda", "nisn": "1020", "jabatan": "Anggota"},
  {"nama": "Muhamad Mika Djaradjenaka S. F", "nisn": "1021", "jabatan": "Anggota"},
  {"nama": "Mutiara 'Ilmi", "nisn": "1022", "jabatan": "Anggota"},
  {"nama": "Naabi Abdullah D.E", "nisn": "1023", "jabatan": "Anggota"},
  {"nama": "Nabilla Zhafiralifia Hariyanto", "nisn": "1024", "jabatan": "Anggota"},
  {"nama": "Nadya Amirah", "nisn": "1025", "jabatan": "Anggota"},
  {"nama": "Nathania Audrey", "nisn": "1026", "jabatan": "Anggota"},
  {"nama": "R. Aj. Ayundra Rania F", "nisn": "1027", "jabatan": "Anggota"},
  {"nama": "Rafi Rizqiyadi", "nisn": "1028", "jabatan": "Anggota"},
  {"nama": "Ramadhani Aliya Wandarti", "nisn": "1029", "jabatan": "Anggota"},
  {"nama": "Rozaq Putra Asmara", "nisn": "1030", "jabatan": "Anggota"},
  ];
  
  // Data jadwal piket - bisa disesuaikan dengan data dari ClassInfo
  late Map<String, List<String>> jadwalPiket;
  
  // Data laporan
  final List<Map<String, dynamic>> laporanHistory = [
    {
      "tanggal": "15 Mei 2025",
      "judul": "Pertemuan Bulanan",
      "deskripsi": "Membahas persiapan ujian semester",
    },
    {
      "tanggal": "10 Mei 2025",
      "judul": "Piket Kelas",
      "deskripsi": "Pembersihan ruang kelas sebelum UTS",
    },
  ];
  
  // Data galeri foto
  final List<String> galeri = [
    "assets/foto_kelas_1.jpg",
    "assets/foto_kelas_2.jpg",
    "assets/foto_kelas_3.jpg",
    "assets/foto_kelas_4.jpg",
    "assets/foto_kelas_5.jpg",
    "assets/foto_kelas_6.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Inisialisasi data berdasarkan parameter yang diterima
    _initializeClassData();
  }

  void _initializeClassData() {
    // Set nama kelas berdasarkan data yang diterima atau default
    namaKelas = widget.selectedClass ?? "7A";
    
    // Set wali kelas berdasarkan data yang diterima atau default
    waliKelas = widget.teacher?.name ?? "Bpk. Aliqidin, S.Pd";
    
    // Set jadwal piket berdasarkan data ClassInfo atau default
    if (widget.classInfo?.schedule != null) {
      jadwalPiket = _generateJadwalPiket(widget.classInfo!.schedule);
    } else {
      jadwalPiket = {
        "Senin": [
          "Achmad Faruq Al Farizi",
          "Achmad Kibi",
          "Adli Azzamy Syauqi",
          "Aisyah Naylaturrohmah",
          "Allysa Selvira Probokusumo",
          "Amanda Budiyono"
        ],
        "Selasa": [
          "Amanda Salsabila Azzahra",
          "Avrillya Rana Zahabiyya",
          "Cahaya Putri Harimurti",
          "Dinar Divianingrum Febriana",
          "Fabriano Asyraafi Subagja",
          "Farrah Avrilia Putri Prasetya"
        ],
        "Rabu": [
          "Fayyaza Maisa Nawra Arya",
          "Felisha Vania Nazila",
          "Fergie Salsabillah Ferianputri",
          "Galuh Dyah Palupi",
          "Kayla Fadia Haya",
          "Levina Fajriyah"
        ],
        "Kamis": [
          "Lintang Kirana Ardhana Aryabhumi",
          "Mohammad Goldy Rayshafa Firnanda",
          "Muhamad Mika Djaradjenaka S. F",
          "Mutiara 'Ilmi",
          "Naabi Abdullah D.E",
          "Nabilla Zhafiralifia Hariyanto"
        ],
        "Jumat": [
          "Nadya Amirah",
          "Nathania Audrey",
          "R. Aj. Ayundra Rania F",
          "Rafi Rizqiyadi",
          "Ramadhani Aliya Wandarti",
          "Rozaq Putra Asmara"
        ],
      };
    }
  }

  Map<String, List<String>> _generateJadwalPiket(List<String> schedule) {
    // Generate jadwal piket berdasarkan schedule dari ClassInfo
    Map<String, List<String>> jadwal = {};
    
    for (int i = 0; i < schedule.length; i++) {
      String hari = schedule[i];
      // Ambil 2 anggota untuk setiap hari (rotating)
      int startIndex = (i * 2) % anggotaKelas.length;
      List<String> piketHari = [
        anggotaKelas[startIndex]["nama"],
        anggotaKelas[(startIndex + 1) % anggotaKelas.length]["nama"],
      ];
      jadwal[hari] = piketHari;
    }
    
    return jadwal;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Consistent shadow style
  List<BoxShadow> get _cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get _buttonShadow => [
    BoxShadow(
      color: AppTheme.primaryColor.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  void _showClassInfo() {
    // Method untuk menampilkan info kelas dari ClassSelectionPage
    if (widget.classInfo != null || widget.teacher != null) {
      _showBottomSheet(
        title: 'Informasi Kelas',
        subtitle: 'Detail lengkap kelas yang dipilih',
        icon: Icons.info_outline,
        items: [
          if (widget.classInfo != null) ...[
            _BottomSheetItem(
              icon: Icons.location_on_outlined,
              title: 'Lokasi Ruang',
              subtitle: widget.classInfo!.location,
              color: Colors.blue,
              onTap: () => Navigator.pop(context),
            ),
            _BottomSheetItem(
              icon: Icons.people_outline,
              title: 'Jumlah Siswa',
              subtitle: '${widget.classInfo!.studentCount} siswa',
              color: Colors.green,
              onTap: () => Navigator.pop(context),
            ),
          ],
          if (widget.teacher != null) ...[
            _BottomSheetItem(
              icon: Icons.person_outline,
              title: 'Walikelas',
              subtitle: widget.teacher!.name,
              color: Colors.purple,
              onTap: () => Navigator.pop(context),
            ),
            _BottomSheetItem(
              icon: Icons.subject_outlined,
              title: 'Mata Pelajaran',
              subtitle: widget.teacher!.subject,
              color: Colors.orange,
              onTap: () => Navigator.pop(context),
            ),
            _BottomSheetItem(
              icon: Icons.phone_outlined,
              title: 'Kontak Walikelas',
              subtitle: widget.teacher!.phone,
              color: Colors.green,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ],
      );
    }
  }

  // Navigasi ke halaman pengaturan kelas
  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassSettingsPage(
          classInfo: widget.classInfo,
          teacher: widget.teacher,
          className: namaKelas,
          waliKelas: waliKelas,
          anggotaKelas: anggotaKelas,
          jadwalPiket: jadwalPiket,
        ),
      ),
    );
  }

  void _showBottomSheet({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<_BottomSheetItem> items,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_largeSpacing)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(_largeSpacing)),
          boxShadow: _cardShadow,
        ),
        padding: const EdgeInsets.fromLTRB(_largeSpacing, _spacing, _largeSpacing, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: _largeSpacing),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            _buildBottomSheetHeader(title, subtitle, icon),
            const SizedBox(height: _spacing),
            // Items
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: _spacing),
              child: _buildBottomSheetItem(item),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(_spacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: AppTheme.primaryColor, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(_spacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: _buttonShadow,
            ),
            child: Icon(icon, color: Colors.white, size: _iconSize + 4),
          ),
          const SizedBox(width: _spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetItem(_BottomSheetItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: _cardShadow,
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_cardPadding),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_spacing),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(_borderRadius - 4),
                ),
                child: Icon(item.icon, color: item.color, size: _iconSize),
              ),
              const SizedBox(width: _spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(_smallSpacing),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: item.color,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          BerandaTab(
            namaKelas: namaKelas,
            waliKelas: waliKelas,
            anggotaKelas: anggotaKelas,
            jadwalPiket: jadwalPiket,
          ),
          AnggotaTab(
            namaKelas: namaKelas,
            waliKelas: waliKelas,
            anggotaKelas: anggotaKelas,
          ),
          GaleriTab(galeri: galeri),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
  return AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          namaKelas,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          '${anggotaKelas.length} Siswa',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.grey[800],
    surfaceTintColor: Colors.transparent,
    toolbarHeight: 70,
    // Perbaikan: Gunakan titleSpacing untuk memberikan ruang yang cukup
    titleSpacing: 16, // Menambah jarak antara leading dan title
    // Perbaikan: Pastikan ada cukup ruang untuk actions
    leadingWidth: 56, // Standard leading width
    actions: [
      // Tambah tombol info kelas jika data tersedia
      if (widget.classInfo != null || widget.teacher != null)
        Container(
          margin: const EdgeInsets.only(right: 4), // Kurangi margin
          child: _buildActionButton(
            onPressed: _showClassInfo,
            gradient: false,
            icon: Icons.info_outline,
            semanticLabel: 'Informasi kelas',
          ),
        ),
      Container(
        margin: const EdgeInsets.only(right: 16), // Margin akhir
        child: _buildActionButton(
          onPressed: _navigateToSettings,
          gradient: false,
          icon: Icons.more_vert_rounded,
          semanticLabel: 'Pengaturan kelas',
        ),
      ),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: _spacing),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(_borderRadius),
                border: Border.all(color: AppTheme.primaryColor, width: 1),
              ),
              child: _buildTabBar(),
            ),
            const SizedBox(height: _spacing),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildActionButton({
  required VoidCallback onPressed,
  required bool gradient,
  required IconData icon,
  String? label,
  required String semanticLabel,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: gradient ? LinearGradient(
        colors: [AppTheme.primaryColor, AppTheme.primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ) : null,
      color: gradient ? null : AppTheme.secondaryColor.withAlpha(51),
      borderRadius: BorderRadius.circular(_borderRadius),
      border: gradient ? null : Border.all(color: AppTheme.primaryColor, width: 1.5),
      boxShadow: gradient ? _buttonShadow : _cardShadow,
    ),
    child: Semantics(
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 12 : 10, // Kurangi padding horizontal
              vertical: 10, // Kurangi padding vertical
            ),
            child: label != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white, size: 16), // Kurangi ukuran icon
                      const SizedBox(width: 6), // Kurangi spacing
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13, // Kurangi ukuran font
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : Icon(
                    icon,
                    color: AppTheme.primaryColor,
                    size: 18, // Kurangi ukuran icon
                  ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicator: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_borderRadius - 2),
        boxShadow: _buttonShadow,
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.all(2),
      labelColor: Colors.white,
      unselectedLabelColor: AppTheme.primaryColor,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: [
        _buildTab(Icons.home_outlined, 'Beranda'),
        _buildTab(Icons.people_outline, 'Anggota'),
        _buildTab(Icons.photo_library_outlined, 'Galeri'),
      ],
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

// Helper class for bottom sheet items
class _BottomSheetItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _BottomSheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}