import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class PhotoItem {
  final String path;
  final DateTime dateTime;
  final bool isAsset;

  PhotoItem({
    required this.path,
    required this.dateTime,
    this.isAsset = false,
  });
}

class GaleriTab extends StatefulWidget {
  final List<String> galeri;

  const GaleriTab({
    super.key,
    required this.galeri,
  });

  @override
  State<GaleriTab> createState() => _GaleriTabState();
}

class _GaleriTabState extends State<GaleriTab> {
  List<PhotoItem> _photos = [];
  final ImagePicker _picker = ImagePicker();
  bool _localeInitialized = false;

  // Daftar hari Senin - Jumat
  final List<String> _weekdays = [
    'Senin',    // Fixed: was 'Minggu' 
    'Selasa', 
    'Rabu',
    'Kamis',
    'Jumat'
  ];

  @override
  void initState() {
    super.initState();
    print('Debug: widget.galeri length = ${widget.galeri.length}');
    print('Debug: widget.galeri contents = ${widget.galeri}');
    _initializeLocale();
    _initializePhotos();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      setState(() {
        _localeInitialized = true;
      });
    } catch (e) {
      print('Error initializing locale: $e');
      // Fallback to default locale
      setState(() {
        _localeInitialized = true;
      });
    }
  }

  void _initializePhotos() {
    // Hanya inisialisasi jika widget.galeri tidak kosong dan kita ingin menampilkan foto default
    // Untuk testing, kita bisa komentari bagian ini dulu
    /*
    _photos = widget.galeri.map((path) => PhotoItem(
      path: path,
      dateTime: DateTime.now(),
      isAsset: true,
    )).toList();
    */
    
    // Mulai dengan list kosong - user harus menambah foto manual
    _photos = [];
  }

  Future<void> _addPhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _photos.add(PhotoItem(
            path: image.path,
            dateTime: DateTime.now(),
            isAsset: false,
          ));
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPhotoSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    onTap: () {
                      Navigator.pop(context);
                      _addPhoto(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPhotoSourceButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    onTap: () {
                      Navigator.pop(context);
                      _addPhoto(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<PhotoItem>> _getWeekdayPhotoStatus() {
    Map<String, List<PhotoItem>> weekdayPhotos = {};
    
    // Initialize semua hari weekdays dengan list kosong
    for (String day in _weekdays) {
      weekdayPhotos[day] = [];
    }
    
    // Group photos berdasarkan hari
    for (PhotoItem photo in _photos) {
      String dayName = _getDayName(photo.dateTime);
      if (weekdayPhotos.containsKey(dayName)) {
        weekdayPhotos[dayName]!.add(photo);
      }
    }
    
    return weekdayPhotos;
  }

  String _getDayName(DateTime dateTime) {
    const indonesianDays = {
      1: 'Senin',    // Monday
      2: 'Selasa',   // Tuesday
      3: 'Rabu',     // Wednesday
      4: 'Kamis',    // Thursday
      5: 'Jumat',    // Friday
      6: 'Sabtu',    // Saturday
      7: 'Minggu',   // Sunday
    };
    
    return indonesianDays[dateTime.weekday] ?? 'Unknown';
  }

  Widget _buildWeekdayStatusCard(String dayName, List<PhotoItem> photos) {
    bool hasPhotos = photos.isNotEmpty;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: hasPhotos ? () => _showDayPhotos(dayName, photos) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hasPhotos 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasPhotos ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: hasPhotos ? Colors.green : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Day info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasPhotos 
                        ? '${photos.length} foto dikirim'
                        : 'Belum ada foto',
                      style: TextStyle(
                        fontSize: 14,
                        color: hasPhotos ? Colors.green : Colors.grey,
                        fontWeight: hasPhotos ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              if (hasPhotos)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDayPhotos(String dayName, List<PhotoItem> photos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Foto $dayName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) => _buildPhotoTile(photos[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoTile(PhotoItem photo, int index) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(photo),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildPhotoImage(photo),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(photo.dateTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoImage(PhotoItem photo) {
    return photo.isAsset
        ? Image.asset(
            photo.path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
          )
        : Image.file(
            File(photo.path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
          );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.broken_image,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  void _showPhotoDetail(PhotoItem photo) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildPhotoImage(photo),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  _localeInitialized 
                    ? DateFormat('EEEE, dd MMMM yyyy - HH:mm', 'id_ID').format(photo.dateTime)
                    : DateFormat('EEEE, dd MMMM yyyy - HH:mm').format(photo.dateTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weekdayPhotos = _getWeekdayPhotoStatus();
    
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Galeri Foto Kelas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status pengiriman Senin - Jumat',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              FloatingActionButton(
                onPressed: _showAddPhotoOptions,
                mini: true,
                child: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
        ),
        
        // Content - FIXED: Removed bottom padding
        Expanded(
          child: _photos.isEmpty && widget.galeri.isEmpty
              ? _buildEmptyState()
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    // bottom: 0, // Removed bottom padding
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero, // Remove ListView's default padding
                    itemCount: _weekdays.length,
                    itemBuilder: (context, index) {
                      String dayName = _weekdays[index];
                      List<PhotoItem> dayPhotos = weekdayPhotos[dayName]!;
                      return _buildWeekdayStatusCard(dayName, dayPhotos);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada foto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Mulai tambahkan foto untuk setiap hari',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}