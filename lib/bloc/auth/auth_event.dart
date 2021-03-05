part of 'auth_bloc.dart';

//@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoadingLoginEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingSucessLoginEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const RegisterEvent(this.name, this.email, this.password);

  @override
  List<Object> get props => [name, email, password];
}

class EmptyEvent extends AuthEvent {
  const EmptyEvent();
  List<Object> get props => [];
}
