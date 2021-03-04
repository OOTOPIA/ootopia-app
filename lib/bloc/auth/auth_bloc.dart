import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepositoryImpl repository = AuthRepositoryImpl();

  AuthBloc(this.repository) : super(LoadingState());

  @override
  AuthState get initialState => InitialState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingState();
    if (event is LoadingSucessLoginEvent) {
      yield LoadingState();
    } else if (event is LoginEvent) {
      yield* _mapUserLoginToState(event);
    } // else if (event is UpdateTimelinePostEvent) {
    //   yield* _mapAlbumUpdatedToState(event);
    // } else if (event is DeleteTimelinePostEvent) {
    //   yield* _mapAlbumDeletedToState(event);
    // }
  }

  Stream<AuthState> _mapUserLoginToState(LoginEvent event) async* {
    try {
      print("VAI LOGAR? ${event.email}");
      var result = (await this.repository.login(event.email, event.password));
      if (result != null) {
        User user = result;
        yield EmptyState();
        yield LoadedSucessState(user);
      }
    } catch (_) {
      yield ErrorState("error on like a post");
    }
  }

  /*final StreamController<Map<String, String>> _loginController =
      StreamController<Map<String, String>>();
  Sink<Map<String, String>> get login => _loginController.sink;
  Stream<User> get onLogin =>
      _loginController.stream.asyncMap((data) => _login(data));

  Future<User> _login(Map<String, String> data) async {
    try {
      print("CALL LOGIN");
      User user =
          (await this.repository.login(data['email'], data['password']));
      print("LOGGED USER " + user.fullname + "; " + user.email);
      return user;
    } catch (error) {
      print("DEU ERRO ${error.toString()}");
      throw Exception('Failed to login ' + error);
    }
  }*/
}
