import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/services/user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>((event, emit) async {
      try{
        if(state is ListLoading){
          return;
        }
        emit(ListLoading());
        var userService = GetIt.I<UserService>();
        var users = await userService.GetUsers();
        emit(ListLoaded(users));
      } catch (e) {
        emit(ListError(e.toString()));
      }
    },);
  }
}
