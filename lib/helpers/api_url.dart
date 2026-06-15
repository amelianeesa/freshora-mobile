class ApiUrl {
  // Ganti IP sesuai dengan IP laptop/xampp kamu (Gunakan 10.0.2.2 jika pakai emulator android bawaan)
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 
  
  static const String services = '$baseUrl/services';
  static const String orders = '$baseUrl/orders';
}