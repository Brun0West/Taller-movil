import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';


class InstitucionalPage extends StatelessWidget {
  const InstitucionalPage({super.key});


  Widget _seccion(String titulo, String contenido) => Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16,
            fontWeight: FontWeight.bold, color: Colors.indigo)),
          const SizedBox(height: 6),
          Text(contenido, style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Institucional'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const NavDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.indigo,
            child: Icon(Icons.store, size: 40, color: Colors.white)),
          const SizedBox(height: 12),
          const Center(child: Text('TechStore S.A.C.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
              color: Colors.indigo))),
          const Divider(height: 24),
          _seccion('Descripción',
            'TechStore S.A.C. es una empresa peruana dedicada a la venta y distribución de '
            'productos tecnológicos, fundada en 2018 en la ciudad de Lima.'),
          _seccion('Misión',
            'Proveer soluciones tecnológicas de calidad a nuestros clientes, ofreciendo una '
            'experiencia de compra digital ágil, confiable y personalizada.'),
          _seccion('Visión',
            'Ser la plataforma de comercio tecnológico líder en el Perú para el año 2030.'),
          _seccion('Línea de Productos',
            '• Laptops y Computadoras\n• Smartphones y Tablets\n'
            '• Periféricos y Accesorios\n• Monitores y Almacenamiento\n• Audio y Video'),
          _seccion('Contacto',
            'Dirección: Av. Universitaria 1801, Lima, Perú\n'
            'Teléfono: +51 990 123 456\n'
            'Email: ventas@techstore.com.pe'),
        ],
      ),
    );
  }
}
