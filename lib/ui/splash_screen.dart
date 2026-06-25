import 'package:flutter/material.dart';
import 'package:freshora_mobile/helpers/user_info.dart';
import 'package:freshora_mobile/ui/onboarding_screen.dart';
import 'package:freshora_mobile/ui/dashboard_page.dart';
import 'package:freshora_mobile/ui/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    var token          = await UserInfo().getToken();
    var onboardingSeen = await UserInfo().getOnboardingSeen();

    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardPage()));
    } else if (!onboardingSeen) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 220,
        ),
      ),
    );
  }
}