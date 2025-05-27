import 'package:flutter/material.dart';

// Model classes for better structure
class ShopItem {
  final String id;
  final String name;
  final int price;
  final Color color;
  bool isPurchased;
  bool isSelected;

  ShopItem({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    this.isPurchased = false,
    this.isSelected = false,
  });
}

class Avatar extends ShopItem {
  final IconData icon;

  Avatar({
    required super.id,
    required super.name,
    required super.price,
    required super.color,
    required this.icon,
    super.isPurchased,
    super.isSelected,
  });
}

class CoolName extends ShopItem {
  final String category;

  CoolName({
    required super.id,
    required super.name,
    required super.price,
    required super.color,
    required this.category,
    super.isPurchased,
    super.isSelected,
  });
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color secondaryColor = Color(0xFF8FA663);
  
  int _userCoins = 500;
  late TabController _tabController;

  // Simplified data initialization
  late final List<Avatar> _avatars;
  late final List<CoolName> _coolNames;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeItems();
  }

  void _initializeItems() {
    _avatars = [
      Avatar(id: 'av1', name: 'Astronaut', price: 100, color: primaryColor, icon: Icons.rocket),
      Avatar(id: 'av2', name: 'Sporty', price: 150, color: Colors.blue, icon: Icons.sports_soccer),
      Avatar(id: 'av3', name: 'Scientist', price: 200, color: Colors.purple, icon: Icons.science),
      Avatar(id: 'av4', name: 'Chef', price: 250, color: Colors.pink, icon: Icons.restaurant),
      Avatar(id: 'av5', name: 'Superhero', price: 300, color: Colors.orange, icon: Icons.flash_on),
      Avatar(id: 'av6', name: 'Musician', price: 250, color: Colors.brown, icon: Icons.music_note),
      Avatar(id: 'av7', name: 'Ninja', price: 350, color: Colors.black87, icon: Icons.star),
      Avatar(id: 'av8', name: 'Wizard', price: 400, color: Colors.deepPurple, icon: Icons.auto_fix_high),
    ];

    _coolNames = [
      CoolName(id: 'nm1', name: 'Pemula Kebersihan', price: 50, color: Colors.green[100]!, category: 'Basic'),
      CoolName(id: 'nm2', name: 'Penjaga Kelas', price: 80, color: Colors.blue[100]!, category: 'Basic'),
      CoolName(id: 'nm3', name: 'Petugas Andalan', price: 120, color: Colors.yellow[600]!, category: 'Role Model'),
      CoolName(id: 'nm4', name: 'Pahlawan Piket', price: 150, color: Colors.orange[400]!, category: 'Role Model'),
      CoolName(id: 'nm5', name: 'Kapten Kebersihan', price: 180, color: Colors.blue[700]!, category: 'Leadership'),
      CoolName(id: 'nm6', name: 'Duta Lingkungan', price: 200, color: Colors.teal[600]!, category: 'Eco Hero'),
      CoolName(id: 'nm7', name: 'Master Piket', price: 250, color: Colors.deepPurple, category: 'Leadership'),
      CoolName(id: 'nm8', name: 'Legenda Kebersihan', price: 300, color: Colors.amber[700]!, category: 'Legendary'),
      CoolName(id: 'nm9', name: 'Pahlawan Tanpa Noda', price: 350, color: Colors.redAccent, category: 'Legendary'),
      CoolName(id: 'nm10', name: 'Penjaga Lingkungan Abadi', price: 400, color: Colors.green[800]!, category: 'Legendary'),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Simplified purchase logic
  void _handleItemTap(ShopItem item, bool isAvatar) {
    if (item.isPurchased) {
      _selectItem(item, isAvatar);
    } else {
      _purchaseItem(item, isAvatar);
    }
  }

  void _purchaseItem(ShopItem item, bool isAvatar) {
    if (_userCoins < item.price) {
      _showInsufficientCoinsDialog();
      return;
    }
    _showPurchaseDialog(item, isAvatar);
  }

  void _confirmPurchase(ShopItem item, bool isAvatar) {
    setState(() {
      _userCoins -= item.price;
      item.isPurchased = true;
      _selectItem(item, isAvatar);
    });
    _showSuccessMessage('${isAvatar ? "Avatar" : "Nama"} "${item.name}" berhasil dibeli dan diaktifkan!');
  }

  void _selectItem(ShopItem item, bool isAvatar) {
    setState(() {
      final items = isAvatar ? _avatars : _coolNames;
      for (var i in items) {
        i.isSelected = false;
      }
      item.isSelected = true;
    });
    _showSuccessMessage('${isAvatar ? "Avatar" : "Nama"} "${item.name}" sedang digunakan!');
  }

  // New method to show coin earning information
  void _showCoinEarningInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.monetization_on, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Flexible(child: Text('Cara Mendapatkan Koin', style: TextStyle(fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEarningMethod(Icons.cleaning_services, 'Menyelesaikan Tugas Piket', '+20 koin'),
            const SizedBox(height: 12),
            _buildEarningMethod(Icons.check_circle, 'Hadir Tepat Waktu', '+10 koin'),
            const SizedBox(height: 12),
            _buildEarningMethod(Icons.group, 'Membantu Teman', '+15 koin'),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningMethod(IconData icon, String method, String reward) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  reward,
                  style: TextStyle(color: Colors.amber[700], fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // UI Helper Methods
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showInsufficientCoinsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Flexible(child: Text('Koin Tidak Cukup')),
          ],
        ),
        content: const Text(
          'Maaf, koin Anda tidak cukup untuk membeli item ini. Dapatkan lebih banyak koin dengan menyelesaikan aktivitas!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(ShopItem item, bool isAvatar) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Pembelian', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildItemPreview(item, isAvatar),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(text: 'Apakah Anda yakin ingin membeli ${isAvatar ? "avatar" : "nama"} '),
                  TextSpan(text: '"${item.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' seharga '),
                  TextSpan(text: '${item.price} koin', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmPurchase(item, isAvatar);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Beli Sekarang'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Batal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemPreview(ShopItem item, bool isAvatar) {
    if (isAvatar) {
      final avatar = item as Avatar;
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: avatar.color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: avatar.color.withOpacity(0.3), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Icon(avatar.icon, size: 40, color: Colors.white),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: item.color.withOpacity(0.3), spreadRadius: 1, blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      );
    }
  }

  Widget _buildStatusChip(ShopItem item) {
    if (!item.isPurchased) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.monetization_on, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text('${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    } else if (item.isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [primaryColor, secondaryColor]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text('Aktif', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.grey[600], size: 14),
            const SizedBox(width: 4),
            Text('Dimiliki', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Coin Balance Header with Earning Info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primaryColor, secondaryColor]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                      child: const Icon(Icons.monetization_on, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saldo Koin', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                        Text('$_userCoins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  ],
                ),
                // Replaced + button with info button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: InkWell(
                    onTap: _showCoinEarningInfo,
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Cara Dapatkan Koin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Tab Bar with Icons and Better Design
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      const Text('Avatar'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      const Text('Nama Keren'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Avatar Grid - Improved alignment
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    childAspectRatio: 0.85, 
                    crossAxisSpacing: 12, 
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = _avatars[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: avatar.isSelected ? primaryColor : Colors.transparent, width: 2),
                      ),
                      child: InkWell(
                        onTap: () => _handleItemTap(avatar, true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Avatar Icon - Fixed size container
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(color: avatar.color, shape: BoxShape.circle),
                                child: Icon(avatar.icon, color: Colors.white, size: 30),
                              ),
                              
                              // Avatar Name - Fixed height container
                              Container(
                                height: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  avatar.name, 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // Status Chip - Fixed position
                              _buildStatusChip(avatar),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Names List - Improved alignment
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _coolNames.length,
                  itemBuilder: (context, index) {
                    final name = _coolNames[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: name.isSelected ? primaryColor : Colors.transparent, width: 2),
                      ),
                      child: InkWell(
                        onTap: () => _handleItemTap(name, false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 64, // Fixed height for consistent alignment
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              // Name Badge - Fixed width
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: name.color, 
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Text(
                                    name.name, 
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Category Badge - Fixed width
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2), 
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  name.category, 
                                  style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ),
                              
                              const SizedBox(width: 12),
                              
                              // Status Chip - Fixed position
                              _buildStatusChip(name),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}