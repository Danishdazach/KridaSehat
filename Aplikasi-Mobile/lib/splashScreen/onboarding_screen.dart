import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kridasehat/logobar/app_logo.dart';
import '../widgets/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  Timer? timer;
  bool hasSwipedBefore = false;

  List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Piket Sekolah Jadi Seru!',
      description: 'KridaSehat mengubah piket sekolah menjadi aktivitas menyenangkan dengan tantangan dan hadiah menarik!',
      imagePath: 'assets/board/board1.png',
      icon: Icons.cleaning_services_rounded,
    ),
    OnboardingPage(
      title: 'Foto, Bersihkan, Menangkan!',
      description: 'Foto area setelah dibersihkan, matikan lampu & AC saat tidak digunakan, dan raih poin untuk kelasmu!',
      imagePath: 'assets/board/board2.png',
      icon: Icons.qr_code_scanner,
    ),
    OnboardingPage(
      title: 'Jadilah Juara Kebersihan',
      description: 'Kumpulkan poin, dapatkan avatar yang menarik, dan jadikan kelasmu sebagai kelas terbersih sekolah!',
      imagePath: 'assets/board/board3.png',
      icon: Icons.emoji_events,
    ),
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer(Duration(seconds: 3), () {
      if (currentPage < pages.length - 1) {
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        pageController.animateToPage(0,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });
  }

  void goToNext() {
    if (currentPage == pages.length - 1) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      pageController.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }
  }

  void skipToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                    if (index > 0) hasSwipedBefore = true;
                  });
                  startTimer();
                },
                itemBuilder: (context, index) {
                  return buildPageContent(pages[index]);
                },
              ),
            ),
            buildBottomSection(),
          ],
        ),
      ),
      floatingActionButton: buildFloatingButton(),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          AppLogo(),
          Spacer(),
          if (currentPage < pages.length - 1)
            TextButton(
              onPressed: skipToLogin,
              child: Text('Lewati', style: TextStyle(color: AppTheme.primaryColor)),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Selesai', style: TextStyle(color: AppTheme.primaryColor)),
            ),
        ],
      ),
    );
  }

  Widget buildPageContent(OnboardingPage page) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),
            buildImageSection(page),
            SizedBox(height: 32),
            Text(
              page.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              page.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (currentPage == 1) ...[
              SizedBox(height: 20),
              buildRewardPreview(),
            ],
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget buildImageSection(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(page.icon, size: 50, color: Colors.green),
                          SizedBox(height: 8),
                          Text('Gambar ${currentPage + 1}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (!hasSwipedBefore && currentPage == 0)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe, size: 14, color: AppTheme.primaryColor),
                      SizedBox(width: 6),
                      Text(
                        'Geser untuk lanjut',
                        style: TextStyle(fontSize: 11, color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRewardPreview() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildRewardItem('Bintang', Icons.star, Colors.amber),
          buildRewardItem('Trophy', Icons.emoji_events, AppTheme.primaryColor),
          buildRewardItem('Badge', Icons.military_tech, Colors.green),
        ],
      ),
    );
  }

  Widget buildRewardItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget buildBottomSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(pages.length, (index) {
              return Container(
                margin: EdgeInsets.only(right: 6),
                width: currentPage == index ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: currentPage == index ? AppTheme.primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          Text(
            '${currentPage + 1}/${pages.length}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingButton() {
    bool isLastPage = currentPage == pages.length - 1;
    
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: goToNext,
        icon: Icon(
          isLastPage ? Icons.check : Icons.arrow_forward,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.icon,
  });
}