import '../../domain/entities/producto.dart';


enum ProductoStatus { idle, loading, success, error }


class ProductoState {
  final List<Producto>   productos;
  final List<Producto>   resultados;
  final ProductoStatus   status;
  final String           errorMessage;
  final String           query;


  const ProductoState({
    this.productos    = const [],
    this.resultados   = const [],
    this.status       = ProductoStatus.idle,
    this.errorMessage = '',
    this.query        = '',
  });


  bool get isLoading => status == ProductoStatus.loading;


  ProductoState copyWith({
    List<Producto>?  productos,
    List<Producto>?  resultados,
    ProductoStatus?  status,
    String?          errorMessage,
    String?          query,
  }) => ProductoState(
    productos:    productos    ?? this.productos,
    resultados:   resultados   ?? this.resultados,
    status:       status       ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    query:        query        ?? this.query,
  );
}
