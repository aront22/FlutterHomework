import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/services/login_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>(
          (event, emit) async {
        try {
          if(state is LoginLoading){
            return;
          }
          emit(LoginLoading());
          var loginService = GetIt.I<LoginService>();
          await loginService.Login(event.email, event.password, event.rememberMe);
          emit(LoginSuccess());
          emit(LoginForm());
        } catch (e) {
          emit(LoginError(e.toString()));
          emit(LoginForm());
        }
      },
    );
    on<LoginAutoLoginEvent>((event, emit) async {
      var loginService = GetIt.I<LoginService>();
      if(loginService.AutoLogin()) {
          emit(LoginSuccess());
      }
    },);
  }
}
