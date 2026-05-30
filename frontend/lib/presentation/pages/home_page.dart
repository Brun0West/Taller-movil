import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TechStore – Inicio'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const NavDrawer(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 80, color: Colors.indigo),
            SizedBox(height: 16),
            Text('Bienvenido a TechStore S.A.C.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Use el menú lateral para navegar.',
              style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
