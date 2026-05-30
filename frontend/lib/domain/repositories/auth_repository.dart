// Esta interfaz (contrato abstracto) define QUÉ puede hacer el repositorio,
// sin importar CÓMO lo hace. Permite cambiar la implementación fácilmente.


abstract class AuthRepository {
  Future<bool> login(String username, String password);
}
