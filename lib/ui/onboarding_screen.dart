import 'package:flutter/material.dart';
import 'package:freshora_mobile/helpers/user_info.dart';
import 'package:freshora_mobile/ui/option_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.local_laundry_service,
      'title': 'Laundry Mudah & Cepat',
      'desc':
          'Pesan layanan laundry kapan saja dan di mana saja hanya dari genggaman tanganmu.',
    },
    {
      'icon': Icons.track_changes_rounded,
      'title': 'Pantau Status Pesanan',
      'desc':
          'Lacak status cucianmu secara real-time mulai dari Pending, Proses, hingga Selesai.',
    },
    {
      'icon': Icons.star_rounded,
      'title': 'Berbagai Pilihan Layanan',
      'desc':
          'Tersedia layanan cuci harian, express, dry clean, setrika, dan paket lengkap sesuai kebutuhanmu.',
    },
  ];

  void _goToOption() async {
    await UserInfo().setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const OptionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol lewati
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: TextButton(
                  onPressed: _goToOption,
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: Color(0xFF6B0D6B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Konten slide
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _buildPage(_pages[i]),
              ),
            ),

            // Indikator + tombol
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const WormEffect(
                      activeDotColor: Color(0xFF6B0D6B),
                      dotColor: Color(0xFFD1A8D1),
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B0D6B),
                        side: const BorderSide(color: Color(0xFF6B0D6B)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _goToOption();
                        }
                      },
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Lanjutkan'
                            : 'Mulai Sekarang',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
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

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          // Bagian atas: ilustrasi (putih)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8F3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                page['icon'] as IconData,
                size: 120,
                color: const Color(0xFF6B0D6B),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Bagian bawah: keterangan (ungu)
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF6B0D6B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  page['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  page['desc'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}