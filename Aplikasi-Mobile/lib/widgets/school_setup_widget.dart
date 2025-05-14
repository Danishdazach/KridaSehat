import 'package:flutter/material.dart';

/// Widget untuk menampilkan UI setup sekolah
class SchoolSetupWidget extends StatelessWidget {
  final VoidCallback onAddSchool;
  final VoidCallback onJoinWithCode;

  const SchoolSetupWidget({
    super.key,  // Pass the key parameter to the super constructor
    required this.onAddSchool,
    required this.onJoinWithCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light blue background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF64B5F6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF1976D2)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Tambahkan Sekolah Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Color(0xFF1976D2)),
                onPressed: onAddSchool,
                tooltip: 'Tambah Sekolah',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tambahkan sekolah atau masukkan kode join untuk bergabung dengan sekolah yang sudah ada.',
            style: TextStyle(color: Color(0xFF546E7A)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Sekolah'),
                  onPressed: onAddSchool,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    side: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.group_add),
                  label: const Text('Join dengan Kode'),
                  onPressed: onJoinWithCode,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    side: const BorderSide(color: Color(0xFF1976D2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Utility untuk menampilkan dialog tambah sekolah
class SchoolDialogHelper {
  /// Menampilkan dialog tambah sekolah baru
  static void showAddSchoolDialog(
    BuildContext context, 
    Function(String, String) onAddSchool
  ) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Sekolah Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Sekolah',
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat Sekolah',
                prefixIcon: Icon(Icons.location_on),
              ),
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
              if (nameController.text.isNotEmpty && addressController.text.isNotEmpty) {
                onAddSchool(nameController.text, addressController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Harap isi semua kolom')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E7E40),
            ),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  /// Menampilkan dialog bergabung dengan kode sekolah
  static void showJoinWithCodeDialog(
    BuildContext context, 
    Function(String) onJoinWithCode
  ) {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bergabung dengan Kode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Kode Join',
                prefixIcon: Icon(Icons.key),
              ),
              textCapitalization: TextCapitalization.characters,
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
              if (codeController.text.isNotEmpty) {
                onJoinWithCode(codeController.text.toUpperCase());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E7E40),
            ),
            child: const Text('Bergabung'),
          ),
        ],
      ),
    );
  }
}
