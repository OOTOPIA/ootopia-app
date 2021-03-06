import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/shared/analytics.server.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepositoryImpl repository = AuthRepositoryImpl();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  AuthBloc(this.repository) : super(LoadingState());

  @override
  AuthState get initialState => InitialState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    LoadingState();
    if (event is LoadingSucessLoginEvent) {
      yield LoadingState();
    } else if (event is LoginEvent) {
      yield* _mapUserLoginToState(event);
    } else if (event is RegisterEvent) {
      yield* _mapUserRegisterToState(event);
    } else if (event is RecoverPasswordEvent) {
      yield* _mapRecoverPasswordToState(event);
    } else if (event is ResetPasswordEvent) {
      yield* _mapResetPasswordToState(event);
    }
  }

  Stream<AuthState> _mapUserLoginToState(LoginEvent event) async* {
    try {
      var result = (await this.repository.login(event.email, event.password));
      if (result != null) {
        User user = result;
        yield EmptyState();
        yield LoadedSucessState(user);
        this.trackingEvents.trackingLoggedIn(user.id!, user.fullname!);
      }
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();
      yield EmptyState();
      if (errorMessage == "INVALID_PASSWORD") {
        yield ErrorState("Invalid email and/or password");
      } else {
        yield ErrorState("Error on login");
      }
    }
  }

  Stream<AuthState> _mapUserRegisterToState(RegisterEvent event) async* {
    try {
      print("NOVA CONTA ${event.email}");
      var result = (await this
          .repository
          .register(event.name, event.email, event.password));
      if (result != null) {
        yield EmptyState();
        yield LoadedSucessState(result);
        this
            .trackingEvents
            .trackingSignupCompletedSignup(result.id!, result.fullname!);
      }
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();

      if (errorMessage == "EMAIL_ALREADY_EXISTS") {
        yield ErrorState(
            "There is already a registered user with that email address");
      } else {
        yield ErrorState("Error on register");
      }
    }
  }

  Stream<AuthState> _mapRecoverPasswordToState(
      RecoverPasswordEvent event) async* {
    try {
      print("RECOVER PASSWORD ${event.email}");
      await this.repository.recoverPassword(event.email);
      yield EmptyState();
      yield LoadedSucessRecoverPasswordState();
      this.trackingEvents.userRecoverPassword();
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();

      if (errorMessage == "USER_NOT_FOUND") {
        yield ErrorRecoverPasswordState(
            "Se este for seu e-mail, um link deverá estar na sua caixa de entrada para que você possa atualizar sua senha.");
      } else {
        yield ErrorRecoverPasswordState(
            "Ocorreu um erro ao recuperar a senha. Tente novamente.");
      }
    }
  }

  Stream<AuthState> _mapResetPasswordToState(ResetPasswordEvent event) async* {
    try {
      print("RESET PASSWORD ${event.newPassword}");
      await this.repository.resetPassword(event.newPassword);
      yield EmptyState();
      yield LoadedSucessResetPasswordState();
      this.trackingEvents.userResetPassword()();
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();

      if (errorMessage == "TOKEN_EXPIRED") {
        yield ErrorResetPasswordState(
            "O token expirou. Envie o e-mail para iniciar o processo de recuperação de senha novamente.");
      } else {
        yield ErrorResetPasswordState(
            "Ocorreu um erro ao atualizar a senha. Tente novamente.");
      }
    }
  }
}
