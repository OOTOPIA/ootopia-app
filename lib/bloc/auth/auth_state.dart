part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

//eventos que sairão do bloc

class EmptyState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class InitialState extends AuthState {
  const InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends AuthState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedSucessState extends AuthState {
  User user;
  LoadedSucessState(this.user);
  @override
  List<Object> get props => [user];
}

class ErrorState extends AuthState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
