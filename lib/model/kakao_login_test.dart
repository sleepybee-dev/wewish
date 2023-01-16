import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:wewish/model/social_login.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      print('login');
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        print('installed');
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          print(e);
          return false;
        }
      } else {
        // install하지 않은 경우
        try {
          print('not install, login');
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          print(e);
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }
}
