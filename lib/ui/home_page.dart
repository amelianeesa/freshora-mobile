import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/order_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OrderModel? activeOrder;
  bool isLoading = true;
  int userId = 4; // Dummy ID User Login (Nanti diambil dari session/UserInfo milik Orang 1)

  @override
  void initState() {
    super.initState();
    fetchActiveOrder();
  }

  fetchActiveOrder() async {
    try {
      final response = await http.get(Uri.parse("${ApiUrl.orders}?user_id=$userId"));
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        List data = res['data'];
        // Cari order yang statusnya belum Selesai (Pending/Proses)
        var active = data.firstWhere((o) => o['status'] != 'Selesai', orElse: () => null);
        if (active != null) {
          setState(() { activeOrder = OrderModel.fromJson(active); });
        }
      }
    } catch (e) { print(e); }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Ungu
            Container(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 25),
              decoration: BoxDecoration(
                color: Color(0xFF6A0DAD),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi, User", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text("Ready for laundry day?", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                      CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickIcon(Icons.style, "Kiloan"),
                      _buildQuickIcon(Icons.dry_cleaning, "Kering"),
                      _buildQuickIcon(Icons.iron, "Setrika"),
                    ],
                  ),
                  SizedBox(height: 25),
                  // Banner Promosi Ungu
                  Container(
                    height: 120,
                    decoration: BoxDecoration(color: Color(0xFF6A0DAD), borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(height: 25),
                  Text("Active Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                  SizedBox(height: 10),
                  
                  // Box Active Order dari API
                  isLoading 
                  ? Center(child: CircularProgressIndicator())
                  : activeOrder == null 
                    ? Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(15)),
                        child: Text("Tidak ada order aktif saat ini.", style: TextStyle(color: Colors.grey)),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(border: Border.all(color: Color(0xFF6A0DAD), style: BorderStyle.solid), borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          title: Text(activeOrder!.serviceName ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Resi: ${activeOrder!.resiCode}\nStatus: ${activeOrder!.status}"),
                          trailing: Text("Rp ${activeOrder!.totalPrice.toString()}", style: TextStyle(color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold)),
                        ),
                      )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(color: Color(0xFF6A0DAD)), borderRadius: BorderRadius.circular(15)),
          child: Icon(icon, color: Color(0xFF6A0DAD), size: 30),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12))
      ],
    );
  }
}