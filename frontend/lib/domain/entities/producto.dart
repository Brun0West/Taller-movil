class Producto {
  final int    id;
  final String codigo;
  final String nombre;
  final String categoria;
  final double precio;
  final int    stock;
  final String descripcion;


  const Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.stock,
    this.descripcion = '',
  });
}
