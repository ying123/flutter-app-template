import 'package:canknow_flutter_ui/utils/LocalStorage.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';

class AuthorizationService {
  static bool get isAuthorized {
    return !TextUtil.isEmpty(getToken());
  }

  static setToken(String token){
    LocalStorage.setString('token', token);
  }

  static getToken(){
    return LocalStorage.getString('token');
  }

  static getUserId() {
    return LocalStorage.getInt('userId');
  }

  static clearToken() {
    LocalStorage.remove('token');
  }

  static clearUser() {
    LocalStorage.remove('user');
    LocalStorage.remove('userId');
  }

  static logout() {
    AuthorizationService.clearToken();
    AuthorizationService.clearUser();
  }
}