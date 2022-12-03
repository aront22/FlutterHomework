import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/user_item.dart';

class UserService{
  final Dio dio;
  final SharedPreferences sharedPreferences;

  UserService(this.dio, this.sharedPreferences);

  Future<List<UserItem>> GetUsers() async {
    String token = sharedPreferences.getString("TOKEN")!;
    dio.options.headers.update("Authorization", (value) => "Bearer $token", ifAbsent: () => "Bearer $token");
    var response = await dio.get("/users");
    var list = response.data as List<Map<String, String>>;

    return list.map((e) => UserItem(e["name"]!, e["avatarUrl"]!)).toList();
  }
}

final userService = UserService(GetIt.I<Dio>(), GetIt.I<SharedPreferences>());