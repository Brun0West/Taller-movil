import '../../domain/entities/producto.dart';


class ProductoModel extends Producto {
  const ProductoModel({
    required super.id,
    required super.codigo,
    required super.nombre,
    required super.categoria,
    required super.precio,
    required super.stock,
    super.descripcion,
  });


  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id:          json['id']          as int,
      codigo:      json['codigo']      as String? ?? '',
      nombre:      json['nombre']      as String? ?? '',
      categoria:   json['categoria']   as String? ?? '',
      precio:      (json['precio']     as num).toDouble(),
      stock:       json['stock']       as int? ?? 0,
      descripcion: json['descripcion'] as String? ?? '',
    );
  }
}
