class ApiUrl {
  // Ganti IP sesuai dengan IP laptop/xampp kamu (Gunakan 10.0.2.2 jika pakai emulator android bawaan)
  // static const String baseUrl = 'http://10.0.2.2:8080/api'; 
  
  static const String baseUrl = 'http://localhost:8080/api';
  static const String register = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';
  static const String updateProfile = '$baseUrl/profile/update';
  static const String services = '$baseUrl/services';
  static const String orders = '$baseUrl/orders';
  static String orderDetail(String resi) => '$baseUrl/orders/$resi';
}