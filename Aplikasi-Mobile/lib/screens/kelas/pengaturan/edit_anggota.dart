import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditMembersPage extends StatefulWidget {
  final String className;
  final String waliKelas;
  final List<Map<String, dynamic>> initialMembers;

  const EditMembersPage({
    super.key,
    required this.className,
    required this.waliKelas,
    required this.initialMembers,
  });

  @override
  EditMembersPageState createState() => EditMembersPageState();
}

class EditMembersPageState extends State<EditMembersPage>
    with SingleTickerProviderStateMixin {
  
  // Design System Constants
  static const _designTokens = _DesignTokens();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late List<Map<String, dynamic>> _members;
  List<Map<String, dynamic>> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _hasChanges = false;
  
  // Available positions/roles
  final List<String> _availablePositions = [
    'Anggota',
    'Ketua Kelas',
    'Wakil Ketua Kelas',
    'Sekretaris',
    'Bendahara',
    'Koordinator Piket',
    'Koordinator Kebersihan',
    'Koordinator Keamanan',
    'Koordinator Olahraga',
    'Koordinator Acara',
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeMembers();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
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
    
    _animationController.forward();
  }

  void _initializeMembers() {
    // Deep copy of the members list
    _members = widget.initialMembers.map((member) => Map<String, dynamic>.from(member)).toList();
    _filteredMembers = List.from(_members);
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      _filterMembers(_searchController.text);
    });
  }

  void _filterMembers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = List.from(_members);
      } else {
        _filteredMembers = _members.where((member) {
          final name = member['nama']?.toString().toLowerCase() ?? '';
          final nisn = member['nisn']?.toString().toLowerCase() ?? '';
          final position = member['jabatan']?.toString().toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          
          return name.contains(searchQuery) || 
                 nisn.contains(searchQuery) || 
                 position.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _AppColors.background,
        appBar: _buildAppBar(),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildMembersList(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Edit Data Anggota',
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
        onPressed: () => _handleBackPress(),
        tooltip: 'Kembali',
      ),
      actions: [
        if (_hasChanges)
          TextButton.icon(
            onPressed: _isLoading ? null : _handleSaveChanges,
            icon: _isLoading 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_rounded),
            label: const Text('Simpan'),
            style: TextButton.styleFrom(
              foregroundColor: _AppColors.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(_designTokens.spacing),
      padding: EdgeInsets.all(_designTokens.largeSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_AppColors.primary.withOpacity(0.1), _AppColors.primary.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.primary.withOpacity(0.2), width: 1),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_designTokens.spacing),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_AppColors.secondary, _AppColors.secondary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_designTokens.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: _AppColors.secondary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: _designTokens.iconSize + 8,
            ),
          ),
          SizedBox(width: _designTokens.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.className,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_members.length} anggota • Wali Kelas: ${widget.waliKelas}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (_hasChanges)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Ada Perubahan',
                style: TextStyle(
                  fontSize: 12,
                  color: _AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _designTokens.spacing),
      padding: EdgeInsets.symmetric(horizontal: _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(color: _AppColors.borderColor),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: _AppColors.textSecondary),
          SizedBox(width: _designTokens.smallSpacing),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama, NISN, atau jabatan...',
                hintStyle: TextStyle(color: _AppColors.textSecondary),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
              color: _AppColors.textSecondary,
            ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(_designTokens.spacing),
        child: _filteredMembers.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = _filteredMembers[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200 + (index * 50)),
                    curve: Curves.easeOutBack,
                    child: _buildMemberCard(member, index),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, int index) {
    final isPengurus = member['jabatan'] != 'Anggota';
    
    return Container(
      margin: EdgeInsets.only(bottom: _designTokens.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_designTokens.borderRadius),
        border: Border.all(
          color: isPengurus 
              ? _AppColors.primary.withOpacity(0.3)
              : _AppColors.borderColor,
        ),
        boxShadow: _designTokens.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEditMemberDialog(member),
          borderRadius: BorderRadius.circular(_designTokens.borderRadius),
          child: Padding(
            padding: EdgeInsets.all(_designTokens.cardPadding),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'member-${member['nisn']}',
                  child: CircleAvatar(
                    backgroundColor: isPengurus 
                        ? _AppColors.primary
                        : _AppColors.neutral.withOpacity(0.3),
                    radius: 28,
                    child: Text(
                      member['nama']?[0]?.toUpperCase() ?? '?',
                      style: TextStyle(
                        color: isPengurus ? Colors.white : _AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: _designTokens.spacing),
                
                // Member Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['nama'] ?? 'Nama tidak tersedia',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NISN: ${member['nisn'] ?? 'Tidak tersedia'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Position Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPengurus 
                        ? _AppColors.primary.withOpacity(0.1)
                        : _AppColors.neutral.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isPengurus 
                          ? _AppColors.primary.withOpacity(0.3)
                          : _AppColors.neutral.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    member['jabatan'] ?? 'Anggota',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPengurus 
                          ? _AppColors.primary
                          : _AppColors.textSecondary,
                    ),
                  ),
                ),
                
                SizedBox(width: _designTokens.smallSpacing),
                Icon(
                  Icons.edit_outlined,
                  color: _AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: _AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada anggota ditemukan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci pencarian',
            style: TextStyle(
              fontSize: 14,
              color: _AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Methods
  void _showEditMemberDialog(Map<String, dynamic> member) {
    final nameController = TextEditingController(text: member['nama']);
    final nisnController = TextEditingController(text: member['nisn']);
    String selectedPosition = member['jabatan'] ?? 'Anggota';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.edit_outlined, color: _AppColors.primary),
                const SizedBox(width: 8),
                const Expanded(child: Text('Edit Data Anggota')),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nisnController,
                    decoration: InputDecoration(
                      labelText: 'NISN',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.numbers_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPosition,
                    decoration: InputDecoration(
                      labelText: 'Jabatan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.work_outline),
                    ),
                    items: _availablePositions.map((position) {
                      return DropdownMenuItem(
                        value: position,
                        child: Text(position),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedPosition = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _AppColors.info.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: _AppColors.info, size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Perubahan data akan disimpan setelah menekan tombol Simpan',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal', style: TextStyle(color: _AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateMember(member, nameController.text, nisnController.text, selectedPosition);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Data Management Methods
  void _updateMember(Map<String, dynamic> member, String name, String nisn, String position) {
    setState(() {
      final index = _members.indexWhere((m) => m['nisn'] == member['nisn']);
      if (index != -1) {
        _members[index]['nama'] = name;
        _members[index]['nisn'] = nisn;
        _members[index]['jabatan'] = position;
        _hasChanges = true;
        _filterMembers(_searchController.text);
      }
    });
    
    _showSuccessSnackbar('Data anggota berhasil diubah');
  }

  // Navigation Methods
  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      return await _showUnsavedChangesDialog();
    }
    return true;
  }

  void _handleBackPress() async {
    if (_hasChanges) {
      final shouldLeave = await _showUnsavedChangesDialog();
      if (shouldLeave) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_outlined, color: _AppColors.warning),
            const SizedBox(width: 8),
            const Text('Ada Perubahan Belum Disimpan'),
          ],
        ),
        content: const Text(
          'Anda memiliki perubahan yang belum disimpan. Apakah Anda yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tetap Di Sini'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    ) ?? false;
  }

  // Save Methods
  Future<void> _handleSaveChanges() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        setState(() {
          _hasChanges = false;
          _isLoading = false;
        });
        
        _showSuccessSnackbar('Semua perubahan berhasil disimpan');
        
        // Return updated data to previous screen
        Navigator.pop(context, {
          'success': true,
          'updatedMembers': _members,
          'message': 'Data anggota berhasil diperbarui',
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Gagal menyimpan perubahan: ${e.toString()}');
      }
    }
  }

  // Utility Methods
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _AppColors.success,
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
            Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// Design System Classes
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
  static const Color secondary = Color(0xFF2196F3);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF00BCD4);
  static const Color neutral = Color(0xFF9E9E9E);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}