// La View solo muestra datos del ViewModel y captura interacciones.
// No contiene lógica de negocio.


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/login_state.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure   = true;


  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }


  Future<void> _onLogin(LoginViewModel vm) async {
    await vm.login();
    if (!mounted) return;
    if (vm.state.status == LoginStatus.success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (vm.state.status == LoginStatus.failure ||
               vm.state.status == LoginStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:         Text(vm.state.errorMessage),
        backgroundColor: Colors.red.shade700,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.store, size: 64, color: Colors.indigo),
                  const SizedBox(height: 8),
                  const Text('TechStore S.A.C.',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
                  const SizedBox(height: 4),
                  Text('Iniciar Sesión',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 28),
                  TextField(
                    controller:   _userCtrl,
                    onChanged:    vm.setUsername,
                    decoration:   const InputDecoration(
                      labelText:   'Usuario',
                      prefixIcon:  Icon(Icons.person_outline),
                      border:      OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller:  _passCtrl,
                    obscureText: _obscure,
                    onChanged:   vm.setPassword,
                    decoration:  InputDecoration(
                      labelText:   'Contraseña',
                      prefixIcon:  const Icon(Icons.lock_outline),
                      border:      const OutlineInputBorder(),
                      suffixIcon:  IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined
                                             : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width:  double.infinity,
                    height: 50,
                    child:  ElevatedButton(
                      onPressed: vm.state.isLoading ? null : () => _onLogin(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      ),
                      child: vm.state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Ingresar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
