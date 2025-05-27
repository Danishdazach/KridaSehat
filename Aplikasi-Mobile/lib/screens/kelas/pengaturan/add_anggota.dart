import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMemberPage extends StatefulWidget {
  final String className;
  final List<Map<String, dynamic>> existingMembers;

  const AddMemberPage({
    super.key,
    required this.className,
    required this.existingMembers,
  });

  @override
  AddMemberPageState createState() => AddMemberPageState();
}

class AddMemberPageState extends State<AddMemberPage>
    with TickerProviderStateMixin {
  
  // Design tokens
  static const _designTokens = _DesignTokens();
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // State variables
  String _selectedJabatan = 'Anggota';
  bool _isLoading = false;
  int _currentStep = 0;
  
  final List<String> _jabatanOptions = [
    'Anggota',
    'Ketua Kelas',
    'Wakil Ketua',
    'Sekretaris',
    'Bendahara',
    'Koordinator Piket',
    'Koordinator Kebersihan',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _namaController.dispose();
    _nisnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tambah Anggota Kelas',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: _AppColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Kembali',
      ),
      actions: [
        if (_currentStep > 0)
          TextButton(
            onPressed: _previousStep,
            child: const Text('Sebelumnya'),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildProgressIndicator(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(_designTokens.spacing),
              child: _buildCurrentStep(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildProgressStep(0, 'Info Dasar', Icons.person_outline),
          _buildProgressConnector(0),
          _buildProgressStep(1, 'Detail', Icons.info_outline),
          _buildProgressConnector(1),
          _buildProgressStep(2, 'Konfirmasi', Icons.check_circle_outline),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String title, IconData icon) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? _AppColors.primary : _AppColors.borderColor,
              shape: BoxShape.circle,
              boxShadow: isCurrent ? [
                BoxShadow(
                  color: _AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : _AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? _AppColors.primary : _AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressConnector(int step) {
    final isActive = _currentStep > step;
    
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 24),
      color: isActive ? _AppColors.primary : _AppColors.borderColor,
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildDetailStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return _buildBasicInfoStep();
    }
  }

  Widget _buildBasicInfoStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'Informasi Dasar',
            'Masukkan data dasar anggota kelas',
            Icons.person_outline,
          ),
          
          SizedBox(height: _designTokens.largeSpacing),
          
          _buildInputField(
            controller: _namaController,
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap siswa',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama lengkap harus diisi';
              }
              if (value.length < 3) {
                return 'Nama minimal 3 karakter';
              }
              return null;
            },
          ),
          
          SizedBox(height: _designTokens.spacing),
          
          _buildInputField(
            controller: _nisnController,
            label: 'NISN',
            hint: 'Masukkan NISN siswa',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'NISN harus diisi';
              }
              if (value.length != 10) {
                return 'NISN harus 10 digit';
              }
              // Check if NISN already exists
              final existingNisn = widget.existingMembers
                  .any((member) => member['nisn'] == value);
              if (existingNisn) {
                return 'NISN sudah terdaftar';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Detail Anggota',
          'Lengkapi informasi kontak dan jabatan',
          Icons.info_outline,
        ),
        
        SizedBox(height: _designTokens.largeSpacing),
        
        _buildInputField(
          controller: _emailController,
          label: 'Email (Opsional)',
          hint: 'nama@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Format email tidak valid';
              }
            }
            return null;
          },
        ),
        
        SizedBox(height: _designTokens.spacing),
        
        _buildInputField(
          controller: _phoneController,
          label: 'Nomor Telepon (Opsional)',
          hint: '08xxxxxxxxxx',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (value.length < 10 || value.length > 15) {
                return 'Nomor telepon tidak valid';
              }
            }
            return null;
          },
        ),
        
        SizedBox(height: _designTokens.spacing),
        
        _buildJabatanSelector(),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepHeader(
          'Konfirmasi Data',
          'Periksa kembali data yang akan ditambahkan',
          Icons.check_circle_outline,
        ),
        
        SizedBox(height: _designTokens.largeSpacing),
        
        _buildConfirmationCard(),
      ],
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _AppColors.primary.withOpacity(0.1),
            _AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(
          color: _AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_designTokens.smallSpacing),
            decoration: BoxDecoration(
              color: _AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(_designTokens.borderRadius - 8),
            ),
            child: Icon(
              icon,
              color: _AppColors.primary,
              size: 24,
            ),
          ),
          SizedBox(width: _designTokens.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: _AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_designTokens.borderRadius),
              borderSide: const BorderSide(color: _AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_designTokens.borderRadius),
              borderSide: const BorderSide(color: _AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_designTokens.borderRadius),
              borderSide: const BorderSide(color: _AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_designTokens.borderRadius),
              borderSide: const BorderSide(color: _AppColors.error, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(_designTokens.spacing),
          ),
        ),
      ],
    );
  }

  Widget _buildJabatanSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jabatan di Kelas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: _designTokens.spacing),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_designTokens.borderRadius),
            border: Border.all(color: _AppColors.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedJabatan,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: _AppColors.primary),
              items: _jabatanOptions.map((String jabatan) {
                // Check if position is already taken
                final isTaken = widget.existingMembers
                    .any((member) => member['jabatan'] == jabatan && jabatan != 'Anggota');
                
                return DropdownMenuItem<String>(
                  value: jabatan,
                  enabled: !isTaken,
                  child: Row(
                    children: [
                      Icon(
                        _getJabatanIcon(jabatan),
                        color: isTaken ? Colors.grey : _AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          jabatan,
                          style: TextStyle(
                            color: isTaken ? Colors.grey : _AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isTaken)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _AppColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Terisi',
                            style: TextStyle(
                              fontSize: 10,
                              color: _AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedJabatan = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationCard() {
    return Container(
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _AppColors.primary,
                radius: 30,
                child: Text(
                  _namaController.text.isNotEmpty ? _namaController.text[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: _designTokens.spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _namaController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedJabatan == 'Anggota' 
                            ? _AppColors.neutral.withOpacity(0.2)
                            : _AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _selectedJabatan,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedJabatan == 'Anggota' 
                              ? _AppColors.neutral
                              : _AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: _designTokens.spacing),
          
          const Divider(),
          
          SizedBox(height: _designTokens.smallSpacing),
          
          _buildConfirmationRow('NISN', _nisnController.text, Icons.badge_outlined),
          if (_emailController.text.isNotEmpty)
            _buildConfirmationRow('Email', _emailController.text, Icons.email_outlined),
          if (_phoneController.text.isNotEmpty)
            _buildConfirmationRow('Telepon', _phoneController.text, Icons.phone_outlined),
          _buildConfirmationRow('Kelas', widget.className, Icons.class_outlined),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _AppColors.primary, size: 20),
          SizedBox(width: _designTokens.smallSpacing),
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 14,
              color: _AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: _designTokens.smallSpacing),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: _AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(_designTokens.spacing),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _AppColors.borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep < 2)
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: _designTokens.spacing),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_designTokens.borderRadius),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _currentStep == 0 ? 'Lanjutkan' : 'Konfirmasi',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )
            else
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _AppColors.success,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: _designTokens.spacing),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_designTokens.borderRadius),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Tambah Anggota',
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

  // Helper methods
  IconData _getJabatanIcon(String jabatan) {
    switch (jabatan) {
      case 'Ketua Kelas':
        return Icons.star;
      case 'Wakil Ketua':
        return Icons.star_half;
      case 'Sekretaris':
        return Icons.edit_note;
      case 'Bendahara':
        return Icons.account_balance_wallet;
      case 'Koordinator Piket':
        return Icons.cleaning_services;
      case 'Koordinator Kebersihan':
        return Icons.eco;
      default:
        return Icons.person;
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create new member data
      final newMember = {
        'nama': _namaController.text,
        'nisn': _nisnController.text,
        'email': _emailController.text.isEmpty ? null : _emailController.text,
        'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
        'jabatan': _selectedJabatan,
        'tanggal_bergabung': DateTime.now().toIso8601String(),
      };

      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'member': newMember,
          'message': 'Anggota berhasil ditambahkan ke kelas ${widget.className}',
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan anggota: ${e.toString()}'),
            backgroundColor: _AppColors.error,
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

// Design System (sama seperti di ClassSettingsPage)
class _DesignTokens {
  const _DesignTokens();
  
  double get borderRadius => 16.0;
  double get cardPadding => 16.0;
  double get spacing => 16.0;
  double get smallSpacing => 8.0;
  double get largeSpacing => 24.0;
  double get iconSize => 24.0;

  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

class _AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color neutral = Color(0xFF9E9E9E);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}