import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Model untuk User Profile
class UserProfile {
  String name;
  String email;
  int level;
  int points;
  int coins;
  String? selectedAvatarId;
  String? selectedNameId;
  String? profileImageUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.level,
    required this.points,
    required this.coins,
    this.selectedAvatarId,
    this.selectedNameId,
    this.profileImageUrl,
  });

  String getInitials() {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}

// Model untuk Shop Item (simplified)
class ShopItem {
  final String id;
  final String name;
  final Color color;
  final IconData? icon; // untuk avatar
  final String? category; // untuk nama

  ShopItem({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    this.category,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color secondaryColor = Color(0xFF8FA663);
  
  // Sample user data
  late UserProfile userProfile;
  
  // Untuk upload foto profil
  File? _selectedImage;
  
  // Sample shop items (sesuai dengan ShopPage)
  final List<ShopItem> availableAvatars = [
    ShopItem(id: 'av1', name: 'Astronaut', color: primaryColor, icon: Icons.rocket),
    ShopItem(id: 'av2', name: 'Sporty', color: Colors.blue, icon: Icons.sports_soccer),
    ShopItem(id: 'av3', name: 'Scientist', color: Colors.purple, icon: Icons.science),
    ShopItem(id: 'av4', name: 'Chef', color: Colors.pink, icon: Icons.restaurant),
    ShopItem(id: 'av5', name: 'Superhero', color: Colors.orange, icon: Icons.flash_on),
  ];

  final List<ShopItem> availableNames = [
    ShopItem(id: 'nm1', name: 'Pemula Kebersihan', color: Colors.green, category: 'Basic'),
    ShopItem(id: 'nm2', name: 'Penjaga Kelas', color: Colors.blue, category: 'Basic'),
    ShopItem(id: 'nm3', name: 'Petugas Andalan', color: Colors.yellow, category: 'Role Model'),
    ShopItem(id: 'nm4', name: 'Pahlawan Piket', color: Colors.orange, category: 'Role Model'),
    ShopItem(id: 'nm5', name: 'Kapten Kebersihan', color: Colors.teal, category: 'Leadership'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize user profile
    userProfile = UserProfile(
      name: 'Danish Zaki',
      email: 'Danish@example.com',
      level: 1,
      points: 500,
      coins: 500,
      selectedAvatarId: 'av1', // Default avatar
      selectedNameId: 'nm2', // Default name
    );
  }

  // Get selected avatar
  ShopItem? get selectedAvatar {
    return availableAvatars.firstWhere(
      (avatar) => avatar.id == userProfile.selectedAvatarId,
      orElse: () => availableAvatars.first,
    );
  }

  // Get selected name
  ShopItem? get selectedName {
    return availableNames.firstWhere(
      (name) => name.id == userProfile.selectedNameId,
      orElse: () => availableNames.first,
    );
  }

  // Helper method to get profile image
  ImageProvider<Object>? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (userProfile.profileImageUrl != null) {
      return NetworkImage(userProfile.profileImageUrl!);
    }
    return null;
  }

  // Helper method to get profile child widget
  Widget? _getProfileChild() {
    if (_selectedImage == null && userProfile.profileImageUrl == null) {
      if (selectedAvatar?.icon != null) {
        return Icon(
          selectedAvatar!.icon,
          size: 50,
          color: Colors.white,
        );
      } else {
        return Text(
          userProfile.getInitials(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }
    }
    return null;
  }

  // Show image source selection dialog
  void _showImageSourceDialog() {
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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Kamera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galeri',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                if (_selectedImage != null || userProfile.profileImageUrl != null)
                  _buildImageSourceOption(
                    icon: Icons.delete_rounded,
                    label: 'Hapus',
                    onTap: _removeImage,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (color ?? primaryColor).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color ?? primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showSuccessMessage('Foto profil berhasil diperbarui!');
      }
    } catch (e) {
      _showErrorMessage('Error memilih gambar: $e');
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      userProfile.profileImageUrl = null;
    });
    _showSuccessMessage('Foto profil berhasil dihapus!');
  }

  // Show avatar selection dialog
  void _showAvatarSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Avatar', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: availableAvatars.length,
            itemBuilder: (context, index) {
              final avatar = availableAvatars[index];
              final isSelected = avatar.id == userProfile.selectedAvatarId;
              
              return InkWell(
                onTap: () {
                  setState(() {
                    userProfile.selectedAvatarId = avatar.id;
                    // Reset foto profil jika memilih avatar
                    _selectedImage = null;
                    userProfile.profileImageUrl = null;
                  });
                  Navigator.pop(context);
                  _showSuccessMessage('Avatar "${avatar.name}" telah dipilih!');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: avatar.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: avatar.color.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 8,
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    avatar.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Show name selection dialog
  void _showNameSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Pilih Nama Keren', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: availableNames.length,
            itemBuilder: (context, index) {
              final name = availableNames[index];
              final isSelected = name.id == userProfile.selectedNameId;
              
              return Card(
                elevation: isSelected ? 4 : 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? primaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: name.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.star, color: Colors.white),
                  ),
                  title: Text(
                    name.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(name.category ?? ''),
                  trailing: isSelected 
                    ? const Icon(Icons.check_circle, color: primaryColor)
                    : null,
                  onTap: () {
                    setState(() {
                      userProfile.selectedNameId = name.id;
                    });
                    Navigator.pop(context);
                    _showSuccessMessage('Nama "${name.name}" telah dipilih!');
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Avatar dengan efek glow dan tombol edit
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: selectedAvatar?.color ?? primaryColor,
                            backgroundImage: _getProfileImage(),
                            child: _getProfileChild(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: primaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // User Name
                    Text(
                      userProfile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Selected Cool Name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        selectedName?.name ?? 'Belum ada nama keren',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Level', '${userProfile.level}', Icons.star),
                        _buildStatItem('Poin', '${userProfile.points}', Icons.trending_up),
                        _buildStatItem('Koin', '${userProfile.coins}', Icons.monetization_on),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Customization Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.palette, color: primaryColor),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Personalisasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Avatar Selection
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedAvatar?.color ?? primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          selectedAvatar?.icon ?? Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: const Text('Avatar', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(selectedAvatar?.name ?? 'Pilih avatar'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _showAvatarSelection,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: Colors.grey[50],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Name Selection
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: selectedName?.color ?? Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: const Text('Nama Keren', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(selectedName?.name ?? 'Pilih nama keren'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _showNameSelection,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: Colors.grey[50],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Account Info Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.info_outline, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Informasi Akun',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow('Nama Lengkap', userProfile.name),
                    _buildInfoRow('Email', userProfile.email),
                    _buildInfoRow('Level', 'Level ${userProfile.level}'),
                    _buildInfoRow('Total Poin', '${userProfile.points} poin'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}