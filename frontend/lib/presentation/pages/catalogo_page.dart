import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../viewmodels/producto_state.dart';
import '../widgets/nav_drawer.dart';


class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}


class _CatalogoPageState extends State<CatalogoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProductoViewModel>().cargarProductos());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductoViewModel>().cargarProductos(),
            tooltip: 'Actualizar catálogo',
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: switch (vm.state.status) {
          ProductoStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
          ProductoStatus.error => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                    size: 56, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(vm.state.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductoViewModel>().cargarProductos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ProductoStatus.success when vm.state.productos.isEmpty =>
            const Center(child: Text('No hay productos disponibles.')),
          ProductoStatus.success => RefreshIndicator(
              onRefresh: () async {
                await context.read<ProductoViewModel>().cargarProductos();
              },
              child: ListView.separated(
                itemCount: vm.state.productos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final producto = vm.state.productos[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text(producto.codigo.isNotEmpty
                            ? producto.codigo[0]
                            : 'P',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(producto.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${producto.categoria} • Código: ${producto.codigo}'),
                          const SizedBox(height: 4),
                          Text('Stock: ${producto.stock} • ${producto.descripcion}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Text('S/ ${producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          _ => const Center(
              child: Text('Cargando catálogo...'),
            ),
        },
      ),
    );
  }
}
