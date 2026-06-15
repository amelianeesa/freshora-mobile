import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/service_model.dart';
import 'main_page.dart';

class BookingPage extends StatefulWidget {
  final ServiceModel service;
  BookingPage({required this.service});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String paymentMethod = 'COD';

  submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(ApiUrl.orders),
          body: {
            'user_id': '4', // Sesuaikan ID user login
            'service_name': widget.service.name,
            'fullname': _nameCtrl.text,
            'whatsapp': _waCtrl.text,
            'address': _addrCtrl.text,
            'pickup_time': _timeCtrl.text,
            'notes': _notesCtrl.text,
            'payment_method': paymentMethod,
            'total_price': '0' // Dihitung admin setelah ditimbang nanti
          }
        );
        
        var res = json.decode(response.body);
        if(response.statusCode == 201) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Sukses!")));
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        }
      } catch (e) { print(e); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Booking ${widget.service.name}"), backgroundColor: Color(0xFF6A0DAD), foregroundColor: Colors.white),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(controller: _nameCtrl, decoration: InputDecoration(labelText: "Nama Lengkap"), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: _waCtrl, decoration: InputDecoration(labelText: "No. WhatsApp"), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: _addrCtrl, decoration: InputDecoration(labelText: "Alamat Penjemputan"), maxLines: 2, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: _timeCtrl, decoration: InputDecoration(labelText: "Jam Jemput (Contoh 14:00)"), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            TextFormField(controller: _notesCtrl, decoration: InputDecoration(labelText: "Catatan Tambahan (Opsional)")),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              decoration: InputDecoration(labelText: "Metode Pembayaran"),
              items: ['COD', 'Transfer', 'QRIS'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) { setState(() { paymentMethod = v!; }); },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: submitBooking,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A0DAD), padding: EdgeInsets.symmetric(vertical: 15)),
              child: Text("Kirim Pesanan", style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}