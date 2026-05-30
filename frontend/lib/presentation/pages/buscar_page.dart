import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../viewmodels/producto_state.dart';
import '../widgets/nav_drawer.dart';


class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});
  @override
  State<BuscarPage> createState() => _BuscarPageState();
}


class _BuscarPageState extends State<BuscarPage> {
  final _ctrl = TextEditingController();


  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Productos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText:   'Buscar por código, nombre o categoría...',
                prefixIcon: const Icon(Icons.search),
                border:     OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled:     true,
                fillColor:  Colors.white,
              ),
              onChanged: (q) {
                if (q.trim().isNotEmpty) {
                  context.read<ProductoViewModel>().buscarProductos(q.trim());
                }
              },
            ),
          ),
          Expanded(
            child: switch (vm.state.status) {
              ProductoStatus.loading => const Center(child: CircularProgressIndicator()),
              ProductoStatus.error   => Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(vm.state.errorMessage),
                ],
              )),
              ProductoStatus.success when vm.state.resultados.isEmpty =>
                const Center(child: Text('No se encontraron productos.')),
              ProductoStatus.success => ListView.separated(
                padding:          const EdgeInsets.symmetric(horizontal: 12),
                itemCount:        vm.state.resultados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, i) {
                  final p = vm.state.resultados[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text(p.nombre[0],
                          style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(p.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('\${p.categoria}  |  Código: \${p.codigo}'),
                      trailing: Text('S/ \${p.precio.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.indigo,
                          fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
              _ => const Center(child: Text('Ingrese un término para buscar.')),
            },
          ),
        ],
      ),
    );
  }
}
