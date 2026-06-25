import 'package:flutter/material.dart';
import 'package:freshora_mobile/bloc/user_bloc.dart';
import 'package:freshora_mobile/model/user.dart';
import 'package:freshora_mobile/widget/success_dialog.dart';
import 'package:freshora_mobile/widget/warning_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading  = false;
  bool _isEditing  = false;
  User? _user;

  final _formKey            = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _phoneController    = TextEditingController();
  final _addressController  = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    setState(() => _isLoading = true);
    UserBloc.getProfile().then((user) {
      setState(() {
        _user                    = user;
        _fullnameController.text = user.fullname ?? '';
        _phoneController.text    = user.phone ?? '';
        _addressController.text  = user.address ?? '';
        _isLoading               = false;
      });
    }, onError: (error) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => const WarningDialog(
          description: 'Gagal memuat profil. Periksa koneksi ke server.',
        ),
      );
    });
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    UserBloc.updateProfile(
      fullname: _fullnameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    ).then((success) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
      showDialog(
        context: context,
        builder: (context) => SuccessDialog(
          description: 'Profil berhasil diperbarui!',
          okClick: () => _loadProfile(),
        ),
      );
    }, onError: (error) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (context) => const WarningDialog(
          description: 'Gagal memperbarui profil. Coba lagi.',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B0D6B),
        foregroundColor: Colors.white,
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B0D6B)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFE8D0E8),
                      child: Text(
                        (_user?.fullname ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Color(0xFF6B0D6B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Badge role
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B0D6B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _user?.role == 'admin' ? 'Administrator' : 'Client',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      '@${_user?.username ?? ''}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // Form field
                    _buildField(
                      label: 'Nama Lengkap',
                      controller: _fullnameController,
                      icon: Icons.badge_outlined,
                      enabled: _isEditing,
                      validator: (v) =>
                          v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),

                    _buildField(
                      label: 'No. WhatsApp',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    _buildField(
                      label: 'Alamat',
                      controller: _addressController,
                      icon: Icons.location_on_outlined,
                      enabled: _isEditing,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Tombol simpan
                    if (_isEditing)
                      SizedBox(
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
                          onPressed: _isLoading ? null : _updateProfile,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Simpan Perubahan',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6B0D6B)),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B0D6B), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: !enabled,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}