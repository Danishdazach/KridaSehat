import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/app_theme.dart'; // Import your app theme colors
import '../kelas/kelas_page.dart'; // Sesuaikan dengan path file KelasPage

// Model untuk data walikelas
class Teacher {
  final String id;
  final String name;
  final String subject;
  final String phone;
  final String email;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.phone,
    required this.email,
  });
}

// Model untuk data kelas lengkap
class ClassInfo {
  final String grade;
  final String className;
  final int studentCount;
  final String location;
  final Teacher? homeRoomTeacher;
  final List<String> schedule;

  ClassInfo({
    required this.grade,
    required this.className,
    required this.studentCount,
    required this.location,
    this.homeRoomTeacher,
    required this.schedule,
  });
}

class ClassSelectionPage extends StatefulWidget {
  const ClassSelectionPage({super.key});
  @override
  _ClassSelectionPageState createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // App Theme Colors
  static const Color accentColor = Color(0xFF34D399);
  static const Color backgroundColor = Color(0xFFF0FDF4);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  String _selectedGrade = '';
  String _selectedClass = '';
  bool _isLoading = false;
  bool _showTeacherManagement = false;

  // Data walikelas
  final Map<String, Teacher> teachers = {
    '7A': Teacher(
      id: 'T001',
      name: 'Ibu Sari Wulandari, S.Pd',
      subject: 'Matematika',
      phone: '081234567890',
      email: 'sari.wulandari@sekolah.edu',
    ),
    '7B': Teacher(
      id: 'T002',
      name: 'Bapak Agus Santoso, S.Pd',
      subject: 'Bahasa Indonesia',
      phone: '081234567891',
      email: 'agus.santoso@sekolah.edu',
    ),
    '8A': Teacher(
      id: 'T003',
      name: 'Ibu Maya Sinta, S.Pd',
      subject: 'IPA',
      phone: '081234567892',
      email: 'maya.sinta@sekolah.edu',
    ),
    '8B': Teacher(
      id: 'T004',
      name: 'Bapak Dedi Rahman, S.Pd',
      subject: 'IPS',
      phone: '081234567893',
      email: 'dedi.rahman@sekolah.edu',
    ),
    '9A': Teacher(
      id: 'T005',
      name: 'Ibu Rina Kartika, S.Pd',
      subject: 'Bahasa Inggris',
      phone: '081234567894',
      email: 'rina.kartika@sekolah.edu',
    ),
  };

  // Data kelas lengkap dengan walikelas
  final Map<String, List<ClassInfo>> availableClasses = {
    'Kelas 7': [
      ClassInfo(
        grade: 'Kelas 7',
        className: '7A',
        studentCount: 32,
        location: 'Lantai 2, Ruang 201',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
      ClassInfo(
        grade: 'Kelas 7',
        className: '7B',
        studentCount: 30,
        location: 'Lantai 2, Ruang 202',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
      ClassInfo(
        grade: 'Kelas 7',
        className: '7C',
        studentCount: 31,
        location: 'Lantai 2, Ruang 203',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
    ],
    'Kelas 8': [
      ClassInfo(
        grade: 'Kelas 8',
        className: '8A',
        studentCount: 33,
        location: 'Lantai 3, Ruang 301',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
      ClassInfo(
        grade: 'Kelas 8',
        className: '8B',
        studentCount: 29,
        location: 'Lantai 3, Ruang 302',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
    ],
    'Kelas 9': [
      ClassInfo(
        grade: 'Kelas 9',
        className: '9A',
        studentCount: 28,
        location: 'Lantai 4, Ruang 401',
        schedule: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'],
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  ClassInfo? get _selectedClassInfo {
    if (_selectedGrade.isEmpty || _selectedClass.isEmpty) return null;
    
    return availableClasses[_selectedGrade]
        ?.firstWhere((classInfo) => classInfo.className == _selectedClass);
  }

  Teacher? get _selectedClassTeacher {
    if (_selectedClass.isEmpty) return null;
    return teachers[_selectedClass];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildGradeSelection(),
                if (_selectedGrade.isNotEmpty) _buildClassSelection(),
                if (_selectedClass.isNotEmpty) _buildSelectedClassInfo(),
                if (_selectedClass.isNotEmpty && _selectedClassTeacher != null) 
                  _buildTeacherInfo(),
                _buildActionButtons(),
                if (_showTeacherManagement)
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Pilih Kelas',
        style: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_add, color: AppTheme.primaryColor, size: 20),
          ),
          onPressed: () => _showAddTeacherDialog(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.school, color: Colors.white, size: 48),
          ),
          SizedBox(height: 16),
          Text(
            'Sistem Manajemen Piket',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pilih kelas Anda untuk mengakses sistem manajemen piket\ndengan informasi walikelas',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pilih Tingkat Kelas'),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: availableClasses.keys.length,
            itemBuilder: (context, index) {
              final grade = availableClasses.keys.elementAt(index);
              final isSelected = _selectedGrade == grade;
              
              return GestureDetector(
                onTap: () => _selectGrade(grade),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : textTertiary.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.3)
                            : textPrimary.withOpacity(0.08),
                        spreadRadius: 0,
                        blurRadius: isSelected ? 15 : 10,
                        offset: Offset(0, isSelected ? 4 : 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      grade,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pilih Kelas'),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: availableClasses[_selectedGrade]!.map((classInfo) {
              final isSelected = _selectedClass == classInfo.className;
              final hasTeacher = teachers.containsKey(classInfo.className);
              
              return GestureDetector(
                onTap: () => _selectClass(classInfo.className),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? accentColor : textTertiary.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? accentColor.withOpacity(0.3)
                            : textPrimary.withOpacity(0.08),
                        spreadRadius: 0,
                        blurRadius: isSelected ? 10 : 5,
                        offset: Offset(0, isSelected ? 3 : 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        classInfo.className,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : textPrimary,
                        ),
                      ),
                      if (hasTeacher) ...[
                        SizedBox(width: 6),
                        Icon(
                          Icons.person,
                          size: 16,
                          color: isSelected ? Colors.white : AppTheme.primaryColor,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedClassInfo() {
    final classInfo = _selectedClassInfo;
    if (classInfo == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: textPrimary.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.class_, color: AppTheme.primaryColor, size: 24),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kelas Terpilih',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                  Text(
                    classInfo.className,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow(Icons.people, 'Jumlah Siswa', '${classInfo.studentCount} siswa'),
          SizedBox(height: 8),
          _buildInfoRow(Icons.schedule, 'Jadwal Piket', classInfo.schedule.join(', ')),
          SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, 'Ruang Kelas', classInfo.location),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo() {
    final teacher = _selectedClassTeacher;
    if (teacher == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(0.1), Colors.indigo.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person, color: Colors.blue, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Walikelas',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      teacher.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTeacherInfoRow(Icons.subject, 'Mata Pelajaran', teacher.subject),
          SizedBox(height: 8),
          _buildTeacherInfoRow(Icons.phone, 'No. Telepon', teacher.phone),
          SizedBox(height: 8),
          _buildTeacherInfoRow(Icons.email, 'Email', teacher.email),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactTeacher('phone', teacher.phone),
                  icon: Icon(Icons.phone, size: 16),
                  label: Text('Telepon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _contactTeacher('email', teacher.email),
                  icon: Icon(Icons.email, size: 16),
                  label: Text('Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 16),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: textSecondary, size: 16),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          if (_selectedClass.isNotEmpty)
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _enterClass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Masuk ke Kelas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          
          SizedBox(height: 12),
          
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _resetSelection,
              style: OutlinedButton.styleFrom(
                foregroundColor: textSecondary,
                side: BorderSide(color: textTertiary),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Reset Pilihan',
                    style: TextStyle(
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => setState(() => _showTeacherManagement = !_showTeacherManagement),
      backgroundColor: AppTheme.primaryColor,
      child: Icon(
        _showTeacherManagement ? Icons.close : Icons.manage_accounts,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    );
  }

  void _selectGrade(String grade) {
    setState(() {
      _selectedGrade = grade;
      _selectedClass = '';
    });
  }

  void _selectClass(String className) {
    setState(() {
      _selectedClass = className;
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedGrade = '';
      _selectedClass = '';
    });
  }

  void _contactTeacher(String type, String contact) {
    String message = type == 'phone' 
        ? 'Menghubungi walikelas via telepon: $contact'
        : 'Mengirim email ke: $contact';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _showAddTeacherDialog() {

    // Cari kelas yang belum memiliki walikelas
    final availableClassNames = <String>[];
    availableClasses.values.forEach((classList) {
      classList.forEach((classInfo) {
        if (!teachers.containsKey(classInfo.className)) {
          availableClassNames.add(classInfo.className);
        }
      });
    });
  }

  void _enterClass() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final teacher = _selectedClassTeacher;
    final classInfo = _selectedClassInfo;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryColor,
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Berhasil Masuk!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Selamat datang di $_selectedClass',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                if (teacher != null) ...[
                  SizedBox(height: 8),
                  Text(
                    'Walikelas: ${teacher.name}',
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 8),
                Text(
                  'Anda dapat mulai mengelola jadwal piket dan berkoordinasi dengan walikelas',
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      
                      // Navigasi ke KelasPage dengan data kelas yang dipilih
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => KelasPage(
                            selectedClass: _selectedClass,
                            selectedGrade: _selectedGrade,
                            classInfo: classInfo,
                            teacher: teacher,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}