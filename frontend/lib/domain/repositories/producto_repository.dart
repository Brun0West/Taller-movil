import '../entities/producto.dart';


abstract class ProductoRepository {
  Future<List<Producto>> listarProductos();
  Future<List<Producto>> buscarProductos(String query);
}
