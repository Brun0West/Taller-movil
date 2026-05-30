// Punto de entrada de la aplicación.
// MultiProvider registra todos los ViewModels disponibles en el árbol de widgets.


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/datasources/api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/producto_repository_impl.dart';
import 'presentation/viewmodels/login_viewmodel.dart';
import 'presentation/viewmodels/producto_viewmodel.dart';
import 'presentation/pages/login_page.dart';


void main() {
  runApp(const TechStoreApp());
}


class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});


  @override
  Widget build(BuildContext context) {
    final api = ApiService();


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(AuthRepositoryImpl(api)),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductoViewModel(ProductoRepositoryImpl(api)),
        ),
      ],
      child: MaterialApp(
        title:                  'TechStore S.A.C.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
