import 'package:flutter/material.dart';
import 'package:freshora_mobile/bloc/logout_bloc.dart';
import 'package:freshora_mobile/helpers/user_info.dart';
import 'package:freshora_mobile/ui/login_page.dart';
import 'package:freshora_mobile/ui/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _fullname = '';
  String _role     = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    var fullname = await UserInfo().getFullname();
    var role     = await UserInfo().getRole();
    setState(() {
      _fullname = fullname ?? '';
      _role     = role ?? 'user';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B0D6B),
        foregroundColor: Colors.white,
        title: const Text(
          'Freshora',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF6B0D6B)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        color: Color(0xFF6B0D6B), size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _fullname,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _role == 'admin' ? 'Administrator' : 'Client',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.person_outline, color: Color(0xFF6B0D6B)),
              title: const Text('Profil Saya'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout',
                  style: TextStyle(color: Colors.red)),
              onTap: () async {
                await LogoutBloc.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $_fullname! 👋',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B0D6B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _role == 'admin'
                  ? 'Selamat datang di panel admin'
                  : 'Selamat datang di Freshora',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            // Area fitur dari teman tim akan ditambahkan di sini
            Center(
              child: Column(
                children: [
                  Icon(Icons.local_laundry_service,
                      size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Fitur laundry akan tampil di sini',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}