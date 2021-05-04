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
    // Emitting a state from the asynchronous generator
    // Branching the executed logic by checking the event type
    LoadingState();
    if (event is LoadingSucessLoginEvent) {
      yield LoadingState();
    } else if (event is LoginEvent) {
      yield* _mapUserLoginToState(event);
    } else if (event is RegisterEvent) {
      yield* _mapUserRegisterToState(event);
    } // else if (event is UpdateTimelinePostEvent) {
    //   yield* _mapAlbumUpdatedToState(event);
    // } else if (event is DeleteTimelinePostEvent) {
    //   yield* _mapAlbumDeletedToState(event);
    // }
  }

  Stream<AuthState> _mapUserLoginToState(LoginEvent event) async* {
    try {
      var result = (await this.repository.login(event.email, event.password));
      if (result != null) {
        User user = result;
        yield EmptyState();
        yield LoadedSucessState(user);
        this.trackingEvents.trackingLoggedIn(user.id, user.fullname);
      }
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();

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
            .trackingSignupCompletedSignup(result.id, result.fullname);
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
}
