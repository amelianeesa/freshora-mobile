import 'package:flutter/material.dart';
import 'package:freshora_mobile/bloc/registrasi_bloc.dart';
import 'package:freshora_mobile/widget/success_dialog.dart';
import 'package:freshora_mobile/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey               = GlobalKey<FormState>();
  bool _isLoading              = false;
  bool _obscurePassword        = true;
  bool _obscureKonfirmasi      = true;

  final _fullnameController    = TextEditingController();
  final _usernameController    = TextEditingController();
  final _passwordController    = TextEditingController();
  final _konfirmasiController  = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF6B0D6B)),
        title: const Text(
          'Buat Akun Baru',
          style: TextStyle(
            color: Color(0xFF6B0D6B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Isi data diri kamu\nuntuk mulai! ✨',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B0D6B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              _fullnameField(),
              const SizedBox(height: 16),

              _usernameField(),
              const SizedBox(height: 16),

              _passwordField(),
              const SizedBox(height: 16),

              _konfirmasiField(),
              const SizedBox(height: 32),

              _buttonRegistrasi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fullnameField() {
    return TextFormField(
      controller: _fullnameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        prefixIcon:
            const Icon(Icons.badge_outlined, color: Color(0xFF6B0D6B)),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B0D6B), width: 2),
        ),
      ),
      validator: (value) {
        if (value!.length < 2) return 'Nama minimal 2 karakter';
        return null;
      },
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
        if (value!.length < 3) return 'Username minimal 3 karakter';
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
        if (value!.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
    );
  }

  Widget _konfirmasiField() {
    return TextFormField(
      controller: _konfirmasiController,
      obscureText: _obscureKonfirmasi,
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        prefixIcon:
            const Icon(Icons.lock_outline, color: Color(0xFF6B0D6B)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () =>
              setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
        ),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B0D6B), width: 2),
        ),
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Konfirmasi password tidak sama';
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
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
            : const Text('Daftar',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    RegistrasiBloc.registrasi(
      username: _usernameController.text,
      fullname: _fullnameController.text,
      password: _passwordController.text,
    ).then((value) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          description: 'Registrasi berhasil! Silakan login.',
          okClick: () => Navigator.pop(context),
        ),
      );
    }, onError: (error) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WarningDialog(
          description: 'Registrasi gagal. Username mungkin sudah digunakan.',
        ),
      );
    });
  }
}