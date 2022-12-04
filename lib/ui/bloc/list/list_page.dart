import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/services/login_service.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/user_item.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User list"),
        actions: [
          IconButton(
              onPressed: () {
                var loginService = GetIt.I<LoginService>();
                loginService.Logout();
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: BlocConsumer<ListBloc, ListState>(
          listenWhen: (_, state) => state is ListError,
          listener: (context, state) {
            if (state is ListError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          buildWhen: (_, state) => state is ListLoaded || state is ListInitial || state is ListLoading,
          builder:  (context, state) {
            if (state is ListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ListLoaded) {
              List<UserItem> items = state.users;
              int itemCount = items.length;

              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return UserListItem(
                    ObjectKey(items[index]),
                    items[index],
                  );
                },
              );
            } else {
              return Container();
            }
          },
        )
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final UserItem user;

  const UserListItem(Key key, this.user) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.network(user.avatarUrl)
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Text(
              user.name,
              style: const TextStyle(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}