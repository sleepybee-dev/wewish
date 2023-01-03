class UserItem {
  String? uId;
  String nickname = 'No Nickname';
  String profileUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU';
  DateTime joinDate = DateTime.now();
  DateTime lastVisitDate = DateTime.now();

  UserItem.fromJson(Map<String, dynamic> json)
      : uId = json['uId'],
        nickname = json['nickname'],
        profileUrl = json['profileUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU';

  Map<String, dynamic> toJson() => <String, dynamic> {
    'uId' : uId,
    'nickname': nickname,
    'profileUrl' : profileUrl
  };
}
