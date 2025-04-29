// import 'package:classhub/core/utils/api.dart';
import 'package:http/http.dart';
import 'package:mmkv/mmkv.dart';

class AuthService {
  final http = Client();
  var mmkv = MMKV.defaultMMKV();

  Future<bool> login(String email, String password) async {
    Future.delayed(const Duration(seconds: 2));

    // final response = await http.post(
    //   Uri.parse("${Api.baseUrl}${Api.loginEndpoint}"),
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    // );
    mmkv.encodeString("classhub-user-token", "123");

    return true;
  }

  Future<String?> getToken() async {
    return mmkv.decodeString("classhub-user-token");
  }
}
