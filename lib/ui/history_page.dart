import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';
import '../model/order_model.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<OrderModel> historyList = [];
  bool isLoading = true;
  int userId = 4;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  fetchHistory() async {
    try {
      final response = await http.get(Uri.parse("${ApiUrl.orders}?user_id=$userId"));
      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        List data = res['data'];
        setState(() {
          historyList = data.map((j) => OrderModel.fromJson(j)).toList();
        });
      }
    } catch (e) { print(e); }
    setState(() { isLoading = false; });
  }

  Color getStatusColor(String status) {
    if (status == 'Pending') return Colors.red;
    if (status == 'Proses') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Laundry"), backgroundColor: Color(0xFF6A0DAD), foregroundColor: Colors.white),
      body: isLoading 
      ? Center(child: CircularProgressIndicator())
      : historyList.isEmpty
        ? Center(child: Text("Belum ada riwayat transaksi."))
        : ListView.builder(
            itemCount: historyList.length,
            padding: EdgeInsets.all(15),
            itemBuilder: (context, index) {
              var order = historyList[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(order.serviceName ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Kode Resi: ${order.resiCode}\n${order.createdAt}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Rp ${order.totalPrice}", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6A0DAD))),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: getStatusColor(order.status ?? "").withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                        child: Text(order.status ?? "", style: TextStyle(color: getStatusColor(order.status ?? ""), fontSize: 11, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}