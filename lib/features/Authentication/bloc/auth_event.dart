sealed class AuthEvent {}



class EventCreatePassword extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  EventCreatePassword({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}


class EventLogin extends AuthEvent {
  final String email;
  final String password;

  EventLogin({
    required this.email,
    required this.password,
  });
}