// La entidad Usuario representa los datos del negocio.
// Es puro Dart, sin dependencias de Flutter ni de bibliotecas externas.


class Usuario {
  final int    id;
  final String username;
  final String nombre;


  const Usuario({
    required this.id,
    required this.username,
    required this.nombre,
  });
}
