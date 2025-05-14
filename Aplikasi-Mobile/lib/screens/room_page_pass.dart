import 'package:flutter/material.dart';

class RoomPagePass extends StatefulWidget {
  final String nama;
  final String email;
  final String kelas;

  const RoomPagePass({
    super.key,
    required this.nama,
    required this.email,
    required this.kelas,
  });

  @override
  State<RoomPagePass> createState() => _RoomPagePassState();
}

class _RoomPagePassState extends State<RoomPagePass> {
  // For demonstrating editing functionality
  final TextEditingController _notesController = TextEditingController();
  final List<String> _scheduleItems = ['Senin: Kelompok 1', 'Selasa: Kelompok 2', 'Rabu: Kelompok 3'];
  final List<String> _uploadedPhotos = [];
  
  // Example class ranking data
  final Map<String, int> _classRankings = {
    '7A': 3,
    '7B': 5,
    '8A': 1,
    '8B': 4,
    '9A': 2,
    '9B': 6,
    '9C': 7,
    '9D': 8,
  };

  @override
  void initState() {
    super.initState();
    // Initialize notes with some sample data
    _notesController.text = 'Bersih-bersih besar dijadwalkan untuk hari Jumat';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Mock photo upload function
  void _addPhoto() {
    setState(() {
      // Simulating adding a new photo with timestamp
      final now = DateTime.now();
      _uploadedPhotos.add('Foto kebersihan ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}');
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto berhasil ditambahkan'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Mock add schedule item function
  void _addScheduleItem() {
    // Create a dialog to add new schedule
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController scheduleController = TextEditingController();
        return AlertDialog(
          title: const Text('Tambah Jadwal Piket'),
          content: TextField(
            controller: scheduleController,
            decoration: const InputDecoration(
              labelText: 'Detail Jadwal (e.g., Kamis: Kelompok 4)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (scheduleController.text.isNotEmpty) {
                  setState(() {
                    _scheduleItems.add(scheduleController.text);
                  });
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jadwal berhasil ditambahkan'),
                      backgroundColor: Color(0xFF4CAF50),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E7E40),
              ),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
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
              // Edit badge indicating this is the edit mode
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Mode Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Room Kelas ${widget.kelas} (Admin)',
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
                    'https://picsum.photos/800/600?random=2', // Different image for edit mode
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
          
          // Full access banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: accentColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Akses Penuh Diberikan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Anda memiliki akses penuh untuk mengedit dan mengelola konten ruangan ini.',
                    style: TextStyle(color: textSecondaryColor),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Selamat datang, ${widget.nama}!',
                          style: const TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                      const Icon(Icons.verified_user, color: accentColor),
                    ],
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
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.star, color: accentColor),
                              SizedBox(width: 10),
                              Text(
                                'Status: Admin Kelas', 
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Sora',
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Class Ranking Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: const BoxDecoration(
                color: bgLightColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Peringkat Kebersihan Kelas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                          color: textPrimaryColor,
                        ),
                      ),
                      Chip(
                        label: Text(
                          'Minggu Ini',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Ranking card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Current class ranking
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (_classRankings[widget.kelas] ?? 0) <= 3
                                ? accentColor.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (_classRankings[widget.kelas] ?? 0) <= 3
                                  ? accentColor
                                  : Colors.orange,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: (_classRankings[widget.kelas] ?? 0) <= 3
                                      ? accentColor
                                      : Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${_classRankings[widget.kelas] ?? "-"}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Kelas ${widget.kelas}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (_classRankings[widget.kelas] ?? 0) <= 3
                                          ? 'Bagus! Pertahankan kebersihan kelas.'
                                          : 'Perlu ditingkatkan lagi kebersihannya.',
                                        style: TextStyle(
                                          color: (_classRankings[widget.kelas] ?? 0) <= 3
                                            ? accentColor
                                            : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: primaryColor),
                                  onPressed: () {
                                    // Edit ranking dialog would go here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Fitur update peringkat akan datang segera'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          
                          // Other class rankings
                          ...List.generate(
                            3,
                            (index) {
                              final sortedClasses = _classRankings.entries.toList()
                                ..sort((a, b) => a.value.compareTo(b.value));
                                
                              if (index < sortedClasses.length) {
                                final entry = sortedClasses[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: index == 0
                                            ? Colors.amber
                                            : index == 1
                                                ? Colors.grey[400]
                                                : Colors.brown[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${entry.value}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'Kelas ${entry.key}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              // View all rankings
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur lihat semua peringkat akan datang segera'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat Semua Peringkat',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Schedule Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jadwal Piket Kelas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                          color: textPrimaryColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Tambah',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _addScheduleItem,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Schedule list
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _scheduleItems.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(Icons.cleaning_services, color: Colors.white),
                          ),
                          title: Text(_scheduleItems[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: primaryColor),
                                onPressed: () {
                                  // Edit schedule item
                                  final TextEditingController controller = TextEditingController(
                                    text: _scheduleItems[index]
                                  );
                                  
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Edit Jadwal Piket'),
                                        content: TextField(
                                          controller: controller,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controller.text.isNotEmpty) {
                                                setState(() {
                                                  _scheduleItems[index] = controller.text;
                                                });
                                                Navigator.pop(context);
                                                
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('Jadwal berhasil diperbarui'),
                                                    backgroundColor: accentColor,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                            ),
                                            child: const Text('Simpan'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Delete schedule item
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Hapus Jadwal'),
                                        content: Text('Apakah Anda yakin ingin menghapus "${_scheduleItems[index]}"?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Batal'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _scheduleItems.removeAt(index);
                                              });
                                              Navigator.pop(context);
                                              
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Jadwal berhasil dihapus'),
                                                  backgroundColor: Colors.red,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Notes Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: bgLightColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Catatan Kebersihan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sora',
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Notes editor
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _notesController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Tulis catatan kebersihan kelas di sini...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              'Simpan Catatan',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // Save notes
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Catatan berhasil disimpan'),
                                  backgroundColor: accentColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Photo Upload Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Foto Kebersihan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                          color: textPrimaryColor,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text(
                          'Tambah Foto',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _addPhoto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Photos grid
                  _uploadedPhotos.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  color: textSecondaryColor,
                                  size: 48,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Belum ada foto kebersihan yang diunggah',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _uploadedPhotos.length,
                          itemBuilder: (context, index) {
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Placeholder for photos
                                  Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.photo,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                  
                                  // Image caption
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.black.withOpacity(0.6),
                                      child: Text(
                                        _uploadedPhotos[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  
                                  // Delete button
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Delete photo
                                        setState(() {
                                          _uploadedPhotos.removeAt(index);
                                        });
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Foto berhasil dihapus'),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          
          // Save Changes Button
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: bgLightColor,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Simpan Semua Perubahan',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Save all changes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Semua perubahan berhasil disimpan'),
                      backgroundColor: accentColor,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: primaryColor,
              child: const Column(
                children: [
                  Text(
                    'Aplikasi Kebersihan Kelas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Versi 1.0.0',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '© 2025 - Semua Hak Dilindungi',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}