import 'package:flutter/material.dart';

class EditClassProfilePage extends StatefulWidget {
  final String initialClassName;
  final String initialWaliKelas;
  final String initialDescription;
  final String initialLocation;

  const EditClassProfilePage({
    super.key,
    required this.initialClassName,
    required this.initialWaliKelas,
    this.initialDescription = '',
    this.initialLocation = '',
  });

  @override
  State<EditClassProfilePage> createState() => _EditClassProfilePageState();
}

class _EditClassProfilePageState extends State<EditClassProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _waliKelasController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupChangeListeners();
  }

  void _initializeControllers() {
    _classNameController.text = widget.initialClassName;
    _waliKelasController.text = widget.initialWaliKelas;
    _descriptionController.text = widget.initialDescription;
    _locationController.text = widget.initialLocation;
  }

  void _setupChangeListeners() {
    _classNameController.addListener(_onFieldChanged);
    _waliKelasController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _locationController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final hasChanges = _classNameController.text != widget.initialClassName ||
        _waliKelasController.text != widget.initialWaliKelas ||
        _descriptionController.text != widget.initialDescription ||
        _locationController.text != widget.initialLocation;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _waliKelasController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFormSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Edit Profil Kelas',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF212121),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: _onBackPressed,
        tooltip: 'Kembali',
      ),
      actions: [
        if (_hasChanges)
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Simpan',
              style: TextStyle(
                color: _isLoading ? Colors.grey : const Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF4CAF50).withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Informasi Kelas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Perbarui informasi dasar kelas Anda',
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

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            controller: _classNameController,
            label: 'Nama Kelas',
            hint: 'Masukkan nama kelas',
            icon: Icons.class_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama kelas tidak boleh kosong';
              }
              if (value.trim().length < 2) {
                return 'Nama kelas minimal 2 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: _waliKelasController,
            label: 'Wali Kelas',
            hint: 'Masukkan nama wali kelas',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama wali kelas tidak boleh kosong';
              }
              if (value.trim().length < 3) {
                return 'Nama wali kelas minimal 3 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: _locationController,
            label: 'Lokasi Ruang',
            hint: 'Contoh: Gedung A Lantai 2',
            icon: Icons.location_on_outlined,
            isRequired: false,
          ),
          const SizedBox(height: 20),
          _buildFormField(
            controller: _descriptionController,
            label: 'Deskripsi Kelas',
            hint: 'Deskripsi singkat tentang kelas (opsional)',
            icon: Icons.description_outlined,
            maxLines: 3,
            isRequired: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF44336), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    if (!_hasChanges) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBackPressed() {
    if (_hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Perubahan Belum Disimpan'),
        content: const Text(
          'Anda memiliki perubahan yang belum disimpan. Apakah Anda yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close edit page
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Color(0xFFF44336)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _saveProfile(); // Save and exit
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan & Keluar'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _classNameController.text = widget.initialClassName;
      _waliKelasController.text = widget.initialWaliKelas;
      _descriptionController.text = widget.initialDescription;
      _locationController.text = widget.initialLocation;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        // Return updated data to previous screen
        final updatedData = {
          'className': _classNameController.text.trim(),
          'waliKelas': _waliKelasController.text.trim(),
          'description': _descriptionController.text.trim(),
          'location': _locationController.text.trim(),
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Profil kelas berhasil diperbarui')),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        Navigator.pop(context, updatedData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Gagal menyimpan: ${e.toString()}')),
              ],
            ),
            backgroundColor: const Color(0xFFF44336),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}