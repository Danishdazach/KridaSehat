import 'package:flutter/material.dart';

// Model untuk data pengguna pada leaderboard
class LeaderboardUser {
  final String id;
  final String name;
  final String email;
  final int score;
  final int rank;
  final String? avatarUrl;
  final DateTime lastActive;

  const LeaderboardUser({
    required this.id,
    required this.name,
    required this.email,
    required this.score,
    required this.rank,
    this.avatarUrl,
    required this.lastActive,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      score: json['score'] ?? 0,
      rank: json['rank'] ?? 0,
      avatarUrl: json['avatarUrl'],
      lastActive: DateTime.tryParse(json['lastActive'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'score': score,
      'rank': rank,
      'avatarUrl': avatarUrl,
      'lastActive': lastActive.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Enum untuk kategori filter
enum LeaderboardCategory {
  all('Semua'),
  weekly('Minggu Ini'),
  monthly('Bulan Ini'),
  yearly('Tahun Ini');

  const LeaderboardCategory(this.displayName);
  final String displayName;
}

// Widget utama untuk papan peringkat
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // Constants
  static const Color primaryColor = Color(0xFF6E7E40);
  static const Color secondaryColor = Color(0xFF8FA663);
  static const int podiumCount = 3;
  
  // State variables
  List<LeaderboardUser> _users = [];
  bool _isLoading = false;
  LeaderboardCategory _selectedCategory = LeaderboardCategory.all;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  // Load leaderboard data
  Future<void> _loadLeaderboardData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Simulasi delay loading
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      
      final users = await _fetchLeaderboardData(_selectedCategory);
      
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data leaderboard';
        });
      }
    }
  }

  // Simulate API call
  Future<List<LeaderboardUser>> _fetchLeaderboardData(LeaderboardCategory category) async {
    // In real app, this would be an API call
    return _getMockData();
  }

  List<LeaderboardUser> _getMockData() {
    final now = DateTime.now();
    return [
      LeaderboardUser(
        id: '1',
        name: 'Ahmad Pratama',
        email: 'ahmad@email.com',
        score: 2850,
        rank: 1,
        lastActive: now.subtract(const Duration(minutes: 30)),
      ),
      LeaderboardUser(
        id: '2',
        name: 'Siti Nurhaliza',
        email: 'siti@email.com',
        score: 2750,
        rank: 2,
        lastActive: now.subtract(const Duration(hours: 2)),
      ),
      LeaderboardUser(
        id: '3',
        name: 'Budi Santoso',
        email: 'budi@email.com',
        score: 2680,
        rank: 3,
        lastActive: now.subtract(const Duration(hours: 5)),
      ),
      LeaderboardUser(
        id: '4',
        name: 'Maya Indira',
        email: 'maya@email.com',
        score: 2590,
        rank: 4,
        lastActive: now.subtract(const Duration(days: 1)),
      ),
      LeaderboardUser(
        id: '5',
        name: 'Rudi Hermawan',
        email: 'rudi@email.com',
        score: 2450,
        rank: 5,
        lastActive: now.subtract(const Duration(days: 2)),
      ),
      LeaderboardUser(
        id: '6',
        name: 'Leni Marlina',
        email: 'leni@email.com',
        score: 2380,
        rank: 6,
        lastActive: now.subtract(const Duration(days: 3)),
      ),
      LeaderboardUser(
        id: '7',
        name: 'Andi Wijaya',
        email: 'andi@email.com',
        score: 2250,
        rank: 7,
        lastActive: now.subtract(const Duration(days: 5)),
      ),
      LeaderboardUser(
        id: '8',
        name: 'Dian Sastro',
        email: 'dian@email.com',
        score: 2180,
        rank: 8,
        lastActive: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  void _onCategoryChanged(LeaderboardCategory category) {
    if (_selectedCategory != category) {
      setState(() => _selectedCategory = category);
      _loadLeaderboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return RefreshIndicator(
      color: primaryColor,
      onRefresh: _loadLeaderboardData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildCategoryFilter(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_users.length >= podiumCount) ...[
                    _buildPodium(),
                    const SizedBox(height: 24),
                  ],
                  _buildLeaderboardList(),
                  const SizedBox(height: 100), // Extra padding at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: LeaderboardCategory.values.map((category) {
            final isSelected = category == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _CategoryChip(
                category: category,
                isSelected: isSelected,
                onTap: () => _onCategoryChanged(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    final top3 = _users.take(podiumCount).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important: Use minimum size needed
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Flexible( // Wrap text to prevent overflow
                child: Text(
                  'TOP $podiumCount LEADERBOARD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Use Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (top3.length > 1) 
                  Flexible(child: _PodiumUser(user: top3[1], height: 80)), // Reduced height
                Flexible(child: _PodiumUser(user: top3[0], height: 100)), // Reduced height
                if (top3.length > 2) 
                  Flexible(child: _PodiumUser(user: top3[2], height: 60)), // Reduced height
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    final startIndex = _users.length >= podiumCount ? podiumCount : 0;
    final listUsers = _users.skip(startIndex).toList();
    
    if (listUsers.isEmpty && startIndex == 0) {
      return _buildEmptyState();
    }

    if (listUsers.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Use minimum size needed
      children: [
        Row(
          children: [
            Icon(Icons.list, color: primaryColor, size: 20),
            const SizedBox(width: 8),
            Flexible( // Prevent text overflow
              child: Text(
                'Peringkat Lengkap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Use Column instead of ListView to prevent overflow
        ...listUsers.asMap().entries.map((entry) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _LeaderboardItem(user: entry.value),
          ),
        ).toList(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Memuat papan peringkat...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLeaderboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.leaderboard, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada data leaderboard',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for category chip
class _CategoryChip extends StatelessWidget {
  final LeaderboardCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? const LinearGradient(
                  colors: [_LeaderboardPageState.primaryColor, _LeaderboardPageState.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _LeaderboardPageState.primaryColor.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          category.displayName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// Separate widget for podium user
class _PodiumUser extends StatelessWidget {
  final LeaderboardUser user;
  final double height;

  const _PodiumUser({
    required this.user,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final (rankColor, rankIcon) = _getRankStyle(user.rank);

    return Column(
      mainAxisSize: MainAxisSize.min, // Use minimum space needed
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50, // Reduced size
              height: 50, // Reduced size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: rankColor, width: 2),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: rankColor.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: _LeaderboardPageState.primaryColor.withOpacity(0.1),
                child: user.avatarUrl != null
                    ? ClipOval(child: Image.network(user.avatarUrl!, fit: BoxFit.cover))
                    : Text(
                        user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _LeaderboardPageState.primaryColor,
                        ),
                      ),
              ),
            ),
            Positioned(
              top: -5,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: rankColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: rankColor.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  rankIcon,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70, // Reduced width
          child: Text(
            user.name.split(' ').first,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12, // Reduced font size
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 10),
              const SizedBox(width: 2),
              Text(
                '${user.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 60, // Reduced width
          height: height,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: rankColor.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '#${user.rank}',
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 16, // Reduced font size
              ),
            ),
          ),
        ),
      ],
    );
  }

  (Color, IconData) _getRankStyle(int rank) {
    return switch (rank) {
      1 => (Colors.amber, Icons.emoji_events),
      2 => (Colors.grey[400]!, Icons.emoji_events),
      3 => (Colors.brown[300]!, Icons.emoji_events),
      _ => (Colors.grey, Icons.emoji_events),
    };
  }
}

// Separate widget for leaderboard item
class _LeaderboardItem extends StatelessWidget {
  final LeaderboardUser user;

  const _LeaderboardItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 70), // Use constraints instead of fixed height
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: user.rank <= 5 
                    ? const LinearGradient(colors: [_LeaderboardPageState.primaryColor, _LeaderboardPageState.secondaryColor])
                    : null,
                color: user.rank > 5 ? Colors.grey[100] : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#${user.rank}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: user.rank <= 5 ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: _LeaderboardPageState.primaryColor.withOpacity(0.1),
              child: user.avatarUrl != null
                  ? ClipOval(child: Image.network(user.avatarUrl!, fit: BoxFit.cover))
                  : Text(
                      user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _LeaderboardPageState.primaryColor,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getLastActiveText(user.lastActive),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            
            // Score Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.white, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        '${user.score}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'poin',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLastActiveText(DateTime lastActive) {
    final difference = DateTime.now().difference(lastActive);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inDays} hari lalu';
    }
  }
}