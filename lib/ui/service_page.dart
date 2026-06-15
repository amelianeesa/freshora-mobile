import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/service_model.dart';
import 'booking_page.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<ServiceModel> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  fetchServices() async {
    try {
      final response = await http.get(Uri.parse(ApiUrl.services));
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        List data = res['data'];
        setState(() {
          services = data.map((json) => ServiceModel.fromJson(json)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(height: 180, color: Color(0xFF6A0DAD)), // Background Header Ungu atas
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Text("Freshora Services", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: isLoading 
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: services.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        var svc = services[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Color(0xFF6A0DAD), width: 1)),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Icon(Icons.local_laundry_service, size: 45, color: Color(0xFF6A0DAD)),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(svc.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(svc.desc, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                      SizedBox(height: 5),
                                      Text("Rp ${svc.price.toStringAsFixed(0)} /kg", style: TextStyle(color: Color(0xFF6A0DAD), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(service: svc)));
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A0DAD), shape: StadiumBorder()),
                                  child: Text("Pilih", style: TextStyle(color: Colors.white, fontSize: 12)),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}