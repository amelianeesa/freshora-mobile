import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';

class TrackingPage extends StatefulWidget {
  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final TextEditingController _resiController = TextEditingController();
  Map<String, dynamic>? _orderData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _resiController.dispose();
    super.dispose();
  }

  Future<void> _cariResi() async {
    final resi = _resiController.text.trim().toUpperCase();
    if (resi.isEmpty) {
      setState(() => _errorMessage = 'Masukkan nomor resi terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _orderData = null;
    });

    try {
      final response = await http.get(Uri.parse(ApiUrl.orderDetail(resi)));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _orderData = data['data']);
      } else {
        setState(() => _errorMessage = 'Resi tidak ditemukan');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Gagal terhubung ke server');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Proses': return Colors.orange;
      case 'Selesai': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Pesanan'),
        backgroundColor: const Color(0xFF660055),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _resiController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Contoh: TRX-C0BCF',
                      labelText: 'Nomor Resi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _cariResi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF660055),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_orderData != null)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _orderData!['resi_code'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _statusColor(_orderData!['status']).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _orderData!['status'],
                              style: TextStyle(
                                color: _statusColor(_orderData!['status']),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _infoRow('Layanan', _orderData!['service_name']),
                      _infoRow('Nama', _orderData!['fullname']),
                      _infoRow('Alamat', _orderData!['address']),
                      _infoRow('Jadwal Pickup', _orderData!['pickup_time']),
                      _infoRow('Pembayaran', _orderData!['payment_method']),
                      _infoRow('Total', 'Rp ${double.parse(_orderData!['total_price'].toString()).toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value ?? '-', style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}