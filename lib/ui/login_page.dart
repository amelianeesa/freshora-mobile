import 'package:flutter/material.dart';
import 'package:freshora_mobile/bloc/login_bloc.dart';
import 'package:freshora_mobile/helpers/user_info.dart';
import 'package:freshora_mobile/ui/dashboard_page.dart';
import 'package:freshora_mobile/ui/registrasi_page.dart';
import 'package:freshora_mobile/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey             = GlobalKey<FormState>();
  bool _isLoading            = false;
  bool _obscurePassword      = true;

  final _usernameController  = TextEditingController();
  final _passwordController  = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                // Header
                const Text(
                  'Selamat Datang\nKembali! 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B0D6B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masuk ke akun Freshora kamu',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Field username
                _usernameField(),
                const SizedBox(height: 16),

                // Field password
                _passwordField(),
                const SizedBox(height: 32),

                // Tombol login
                _buttonLogin(),
                const SizedBox(height: 24),

                // Link ke register
                _linkRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Username',
        prefixIcon:
            const Icon(Icons.person_outline, color: Color(0xFF6B0D6B)),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B0D6B), width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Username harus diisi';
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon:
            const Icon(Icons.lock_outline, color: Color(0xFF6B0D6B)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B0D6B), width: 2),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Password harus diisi';
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B0D6B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (!_isLoading) _submit();
          }
        },
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Text('Masuk',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    LoginBloc.login(
      username: _usernameController.text,
      password: _passwordController.text,
    ).then((value) async {
      await UserInfo().setToken(value.token.toString());
      await UserInfo().setUserID(int.parse(value.userID.toString()));
      await UserInfo().setRole(value.role.toString());
      await UserInfo().setFullname(value.fullname.toString());

      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }, onError: (error) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WarningDialog(
          description: 'Login gagal. Periksa username dan password kamu.',
        ),
      );
    });
  }

  Widget _linkRegistrasi() {
    return Center(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrasiPage()),
        ),
        child: RichText(
          text: const TextSpan(
            text: 'Belum punya akun? ',
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: 'Daftar di sini',
                style: TextStyle(
                  color: Color(0xFF6B0D6B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}