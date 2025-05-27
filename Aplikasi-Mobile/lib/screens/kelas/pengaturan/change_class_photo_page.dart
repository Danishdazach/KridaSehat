import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChangeClassPhotoPage extends StatefulWidget {
  final String className;
  final String? currentPhotoUrl;

  const ChangeClassPhotoPage({
    super.key,
    required this.className,
    this.currentPhotoUrl,
  });

  @override
  State<ChangeClassPhotoPage> createState() => _ChangeClassPhotoPageState();
}

class _ChangeClassPhotoPageState extends State<ChangeClassPhotoPage>
    with SingleTickerProviderStateMixin {
  
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildCurrentPhoto(),
            const SizedBox(height: 32),
            _buildPhotoOptions(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Ganti Foto Kelas',
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
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali',
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF4CAF50).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4CAF50),
                  const Color(0xFF4CAF50).withOpacity(0.8),
                ],
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
              Icons.image_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pilih foto baru untuk kelas Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Saat Ini',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : widget.currentPhotoUrl != null
                      ? Image.network(
                          widget.currentPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPhotoPlaceholder(),
                        )
                      : _buildPhotoPlaceholder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: Color(0xFF9E9E9E),
          ),
          SizedBox(height: 8),
          Text(
            'Belum ada foto',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Sumber Foto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOptionCard(
                'Kamera',
                'Ambil foto langsung',
                Icons.camera_alt_outlined,
                const Color(0xFF2196F3),
                () => _pickImage(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOptionCard(
                'Galeri',
                'Pilih dari galeri',
                Icons.photo_outlined,
                const Color(0xFF9C27B0),
                () => _pickImage(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (_selectedImage != null && !_isLoading) ? _savePhoto : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
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
                    'Simpan Foto',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedImage != null)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _removePhoto,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF44336),
                side: const BorderSide(color: Color(0xFFF44336)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hapus Foto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        
        _animationController.reset();
        _animationController.forward();

        _showSuccessSnackbar('Foto berhasil dipilih');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal mengambil foto: ${e.toString()}');
    }
  }

  void _removePhoto() {
    setState(() {
      _selectedImage = null;
    });
    _showSuccessSnackbar('Foto dihapus');
  }

  Future<void> _savePhoto() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi upload foto (ganti dengan logic upload sebenarnya)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showSuccessSnackbar('Foto kelas berhasil diperbarui');
        
        // Return result ke halaman sebelumnya
        Navigator.pop(context, {
          'success': true,
          'photoPath': _selectedImage!.path,
          'message': 'Foto kelas berhasil diperbarui',
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Gagal menyimpan foto: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
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
}