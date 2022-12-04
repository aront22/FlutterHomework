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
      dio.options.headers["Authorization"] = "Bearer $token";
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
    if(sharedPreferences.containsKey("TOKEN")){
      var token = sharedPreferences.getString("TOKEN");
      dio.options.headers["Authorization"] = "Bearer $token";
      return true;
    }

    return false;
  }

  void Logout()
  {
    sharedPreferences.clear();
  }
}