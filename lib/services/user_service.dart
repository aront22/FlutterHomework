import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/user_item.dart';

class UserService{
  final Dio dio;
  final SharedPreferences sharedPreferences;

  UserService(this.dio, this.sharedPreferences);

  Future<List<UserItem>> GetUsers() async {
    try
    {
      var response = await dio.get("/users");
      var list = response.data as List<dynamic>;

      return list.map((e) => UserItem(e["name"]!, e["avatarUrl"]!)).toList();
    }
    catch (e) {
      if(e is DioError){
        throw e.response!.data["message"];
      }
      throw e.toString();
    }
  }
}