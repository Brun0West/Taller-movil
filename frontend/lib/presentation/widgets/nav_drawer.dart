// lib/presentation/widgets/nav_drawer.dart

import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/institucional_page.dart';
import '../pages/catalogo_page.dart';
import '../pages/buscar_page.dart';
import '../pages/home_page.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.store, size: 32, color: Colors.indigo),
                ),
                const SizedBox(height: 8),
                const Text(
                  'TechStore S.A.C.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sistema de Gestión',
                  style: TextStyle(color: Colors.indigo.shade100, fontSize: 13),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text('Información Institucional'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InstitucionalPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Catálogo de Productos'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const CatalogoPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.search_outlined),
            title: const Text('Buscador de Productos'),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BuscarPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (r) => false,
            ),
          ),
        ],
      ),
    );
  }
}
