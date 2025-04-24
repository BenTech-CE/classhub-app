import 'package:mmkv/mmkv.dart';

class AuthService {
  var mmkv = MMKV.defaultMMKV();

  Future<bool> login(String email, String password) async {
    Future.delayed(const Duration(seconds: 2));

    mmkv.encodeString("classhub-user-token", "123");

    return true;
  }

  Future<String?> getToken() async {
    return mmkv.decodeString("classhub-user-token");
  }
}
