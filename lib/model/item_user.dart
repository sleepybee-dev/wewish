class UserItem {
  String? uId;
  String nickname = 'No Nickname';
  String profileUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU';
  List<String> hashTag = [];
  String social = 'kakao'; // kakao, apple
  String email = '';
  DateTime joinDate = DateTime.now();
  DateTime lastVisitDate = DateTime.now();

  UserItem();

  UserItem.fromJson(Map<String, dynamic> json)
      : uId = json['uId'],
        nickname = json['nickname'],
        hashTag = json['hashtag'] == null
            ? []
            : (json['hashtag'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        profileUrl = json['profileUrl'] ??
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU',
        social = json['social'] == null ? 'kakao' : json['social'] as String,
        email = json['email'] == null ? '' : json['email'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uId': uId,
        'nickname': nickname,
        'profileUrl': profileUrl,
        'hashtag': hashTag,
        'social': social,
        'email': email,
        'joinDate': joinDate,
        'lastVisitDate': lastVisitDate
      };
}
