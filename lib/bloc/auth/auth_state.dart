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
  final User user;
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

class LoadedSucessRecoverPasswordState extends AuthState {
  LoadedSucessRecoverPasswordState();
  @override
  List<Object> get props => [];
}

class ErrorRecoverPasswordState extends AuthState {
  final String message;
  const ErrorRecoverPasswordState(this.message);
  @override
  List<Object> get props => [message];
}

class LoadedSucessResetPasswordState extends AuthState {
  LoadedSucessResetPasswordState();
  @override
  List<Object> get props => [];
}

class ErrorResetPasswordState extends AuthState {
  final String message;
  const ErrorResetPasswordState(this.message);
  @override
  List<Object> get props => [message];
}
