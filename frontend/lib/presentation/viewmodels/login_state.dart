// LoginState es un objeto inmutable que representa el estado actual
// de la pantalla de Login. Utiliza el patrón copyWith para mutaciones.


enum LoginStatus { idle, loading, success, failure, error }


class LoginState {
  final String      username;
  final String      password;
  final LoginStatus status;
  final String      errorMessage;


  const LoginState({
    this.username     = '',
    this.password     = '',
    this.status       = LoginStatus.idle,
    this.errorMessage = '',
  });


  bool get isLoading  => status == LoginStatus.loading;
  bool get isFormValid => username.trim().isNotEmpty && password.isNotEmpty;


  LoginState copyWith({
    String?      username,
    String?      password,
    LoginStatus? status,
    String?      errorMessage,
  }) =>
      LoginState(
        username:     username     ?? this.username,
        password:     password     ?? this.password,
        status:       status       ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
