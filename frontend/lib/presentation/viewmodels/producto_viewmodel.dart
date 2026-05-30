import 'package:flutter/foundation.dart';
import '../../domain/repositories/producto_repository.dart';
import 'producto_state.dart';


class ProductoViewModel extends ChangeNotifier {
  final ProductoRepository _repo;
  ProductoState _state = const ProductoState();
  ProductoState get state => _state;


  ProductoViewModel(this._repo);


  Future<void> cargarProductos() async {
    _state = _state.copyWith(status: ProductoStatus.loading);
    notifyListeners();
    try {
      final lista = await _repo.listarProductos();
      _state = _state.copyWith(
        productos:  lista,
        resultados: lista,
        status:     ProductoStatus.success,
      );
    } catch (_) {
      _state = _state.copyWith(
        status:       ProductoStatus.error,
        errorMessage: 'Error al cargar productos. Verifique el servidor.',
      );
    }
    notifyListeners();
  }


  Future<void> buscarProductos(String query) async {
    _state = _state.copyWith(query: query, status: ProductoStatus.loading);
    notifyListeners();
    try {
      final lista = await _repo.buscarProductos(query);
      _state = _state.copyWith(
        resultados: lista,
        status:     ProductoStatus.success,
      );
    } catch (_) {
      _state = _state.copyWith(
        status:       ProductoStatus.error,
        errorMessage: 'Error al buscar. Verifique la conexión.',
      );
    }
    notifyListeners();
  }
}
