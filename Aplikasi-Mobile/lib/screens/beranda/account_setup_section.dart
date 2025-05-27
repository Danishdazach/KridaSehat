import 'package:flutter/material.dart';
import '../../widgets/app_theme.dart';
import 'shared_widgets.dart';

// Account Setup Section - Updated untuk mencerminkan akun NISN yang sudah ada
class AccountSetupSection extends StatelessWidget {
  const AccountSetupSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Lengkapi Profil Anda'),
          const SizedBox(height: 4),
          const Text(
            'Akun Anda sudah terdaftar. Lengkapi profil untuk pengalaman yang lebih personal',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          _buildAccountSetupCard(context),
        ],
      ),
    );
  }

  Widget _buildAccountSetupCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_circle,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lengkapi Profil Anda',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tambahkan nama, kelas, dan preferensi jadwal piket',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSetupStep(
                  icon: Icons.badge,
                  title: 'Nama',
                  subtitle: 'Tambah identitas',
                  isCompleted: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSetupStep(
                  icon: Icons.school,
                  title: 'Kelas',
                  subtitle: 'Pilih kelas',
                  isCompleted: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSetupStep(
                  icon: Icons.schedule,
                  title: 'Jadwal',
                  subtitle: 'Atur preferensi',
                  isCompleted: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _navigateToAccountSetup(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Lengkapi Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSetupStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withOpacity(0.3)
              : AppTheme.textTertiary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withOpacity(0.1)
                  : AppTheme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isCompleted ? Colors.green : AppTheme.textTertiary,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green : AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToAccountSetup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountSetupPage()),
    );
  }
}

// Account Setup Page - Clean version without debug code
class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({Key? key}) : super(key: key);

  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  String _selectedClass = '';
  List<String> _selectedSchedulePreferences = [];

  final List<String> _availableClasses = [
    'X IPA 1', 'X IPA 2', 'X IPA 3',
    'X IPS 1', 'X IPS 2', 'X IPS 3',
    'XI IPA 1', 'XI IPA 2', 'XI IPA 3',
    'XI IPS 1', 'XI IPS 2', 'XI IPS 3',
    'XII IPA 1', 'XII IPA 2', 'XII IPA 3',
    'XII IPS 1', 'XII IPS 2', 'XII IPS 3',
  ];

  final List<String> _scheduleOptions = [
    'Senin Pagi', 'Senin Siang',
    'Selasa Pagi', 'Selasa Siang',
    'Rabu Pagi', 'Rabu Siang',
    'Kamis Pagi', 'Kamis Siang',
    'Jumat Pagi', 'Jumat Siang',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _nameController.addListener(() {
      setState(() {}); // Rebuild UI when text changes
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lengkapi Profil',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildProgressIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNameSetupStep(),
                    _buildClassSetupStep(),
                    _buildScheduleSetupStep(),
                  ],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index <= _currentStep;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive 
                    ? AppTheme.primaryColor 
                    : AppTheme.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNameSetupStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Siapa nama Anda?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nama ini akan digunakan untuk identifikasi dalam jadwal piket',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Masukkan nama lengkap Anda',
              prefixIcon: const Icon(Icons.person, color: AppTheme.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.textTertiary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppTheme.textTertiary.withOpacity(0.3)),
              ),
            ),
            style: const TextStyle(fontSize: 16),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          if (_nameController.text.trim().isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Halo, ${_nameController.text.trim()}!',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassSetupStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Kelas Anda',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kelas akan menentukan jadwal piket yang tersedia untuk Anda',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
              ),
              itemCount: _availableClasses.length,
              itemBuilder: (context, index) {
                final className = _availableClasses[index];
                final isSelected = _selectedClass == className;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedClass = className;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.textTertiary.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        className,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSetupStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferensi Jadwal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih waktu yang Anda sukai untuk piket (opsional)',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedSchedulePreferences.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_selectedSchedulePreferences.length} waktu dipilih',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _scheduleOptions.length,
              itemBuilder: (context, index) {
                final schedule = _scheduleOptions[index];
                final isSelected = _selectedSchedulePreferences.contains(schedule);
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSchedulePreferences.remove(schedule);
                        } else {
                          _selectedSchedulePreferences.add(schedule);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1) 
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? AppTheme.primaryColor 
                              : AppTheme.textTertiary.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
                              key: ValueKey(isSelected),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            schedule,
                            style: TextStyle(
                              color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final canProceed = _canProceed();
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: _previousStep,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.textTertiary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Kembali',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: canProceed ? _nextStep : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: canProceed 
                      ? AppTheme.primaryColor 
                      : AppTheme.textTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: canProceed ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Text(
                    _currentStep == _totalSteps - 1 ? 'Selesai' : 'Lanjut',
                    style: TextStyle(
                      color: canProceed ? Colors.white : AppTheme.textTertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _selectedClass.isNotEmpty;
      case 2:
        return true; // Schedule step is optional
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeSetup() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text('Profil Lengkap!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, ${_nameController.text.trim()}!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Kelas: $_selectedClass'),
            if (_selectedSchedulePreferences.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Preferensi: ${_selectedSchedulePreferences.length} waktu dipilih'),
            ],
            const SizedBox(height: 12),
            const Text(
              'Profil Anda telah berhasil dilengkapi. Sekarang Anda dapat menggunakan semua fitur aplikasi.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to main page
              // Optionally navigate to specific page or refresh main page
            },
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Mulai Menggunakan'),
          ),
        ],
      ),
    );
  }
}