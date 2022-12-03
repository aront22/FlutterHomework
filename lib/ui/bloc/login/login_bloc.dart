import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/services/login_service.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>(
          (event, emit) async {
        try {
          emit(LoginLoading());
          await loginService.Login(event.email, event.password, event.rememberMe);
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginError(e.toString()));
        } finally {
          emit(LoginForm());
        }
      },
    );
  }
}
