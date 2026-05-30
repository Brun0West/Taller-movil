import '../../core/constants.dart';
import '../../data/datasources/api_service.dart';
import '../../domain/repositories/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  final ApiService _api;
  AuthRepositoryImpl(this._api);


  @override
  Future<bool> login(String username, String password) async {
    final resp = await _api.post(
      AppConstants.loginEndpoint,
      {'username': username, 'password': password},
    );
    return resp['ok'] == true;
  }
}
