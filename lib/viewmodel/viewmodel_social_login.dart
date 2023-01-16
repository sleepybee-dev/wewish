import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:wewish/model/firebase_auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wewish/model/social_login.dart';

class SocialLoginViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false;
  kakao.User? user;

  SocialLoginViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();

      // firebase auth에 필요한 데이터 보내주는 코드
      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async {
    await _socialLogin.logout(); // 카카오
    await FirebaseAuth.instance.signOut(); // 파이어베이스
    isLogined = false;
    user = null;
  }
}
