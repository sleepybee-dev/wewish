class UserItem {
  String? uId;
  String nickname = 'No Nickname';
  List<String> nicknameArray = [];
  String? profileUrl;
  List<String> hashTag = [];
  String social = 'kakao'; // kakao, apple
  String email = '';
  DateTime joinDate = DateTime.now();
  DateTime lastVisitDate = DateTime.now();

  UserItem();

  UserItem.fromJson(Map<String, dynamic> json)
      : uId = json['uId'],
        nickname = json['nickname'],
        nicknameArray = json['nicknameArray'] == null
            ? json['nickname'].toString().split('')
            : (json['nicknameArray'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        hashTag = json['hashtag'] == null
            ? []
            : (json['hashtag'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        profileUrl = json['profileUrl'],
        social = json['social'] == null ? 'kakao' : json['social'] as String,
        email = json['email'] == null ? '' : json['email'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uId': uId,
        'nickname': nickname,
        'nicknameArray': nicknameArray,
        'profileUrl': profileUrl,
        'hashtag': hashTag,
        'social': social,
        'email': email,
        'joinDate': joinDate,
        'lastVisitDate': lastVisitDate
      };
}
