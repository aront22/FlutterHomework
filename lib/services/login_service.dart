import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService{
  final Dio dio;
  final SharedPreferences sharedPreferences;

  LoginService(this.dio, this.sharedPreferences);

  Future<String> Login(String email, String password, bool rememberMe) async
  {
    try
    {
      var response = await dio.post("/login", data: {
        "email": email,
        "password": password
      });
      Map<String, String> result = response.data as Map<String, String>;
      String token = result["token"]!;
      dio.options.headers.update("Authorization", (value) => "Bearer $token", ifAbsent: () => "Bearer $token");
      if(rememberMe) {
        await sharedPreferences.setString("TOKEN", token);
      }
      return token;
    }
    catch (e) {
      if(e is DioError){
        throw e.response!.data["message"];
      }
      throw e.toString();
    }
  }

  bool AutoLogin()
  {
    return sharedPreferences.containsKey("TOKEN");
  }

  void Logout()
  {
    sharedPreferences.clear();
  }
}