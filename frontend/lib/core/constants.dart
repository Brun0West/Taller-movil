class AppConstants {
  // Para emulador Android, usar 10.0.2.2 en lugar de localhost
  // Para dispositivo físico, usar la IP de la PC en la red local (ej: 192.168.1.x)
  static const String baseUrl = 'https://taller-movil-d4jk.onrender.com';

  // Endpoints
  static const String loginEndpoint = '$baseUrl/api/login';
  static const String productosEndpoint = '$baseUrl/api/productos';
  static const String buscarEndpoint = '$baseUrl/api/productos/buscar';
}
