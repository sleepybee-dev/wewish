import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:cp949_dart/cp949_dart.dart' as cp949;

class CategoryParser {

  static Future<Map<String, List<String>>> getCategoryMap(Category category) async {
    String url = category.url;
    Map<String, String> headers = {
      "responseType": "text/csv",
    };
    http.Response response = await http.get(Uri.parse(url),headers:headers);
    Logger logger = Logger(printer:PrettyPrinter());
    List<String> lines = response.body.split('\r\n');

    if (response.statusCode == 200) {
      List<List<dynamic>> rowList = const CsvToListConverter().convert(cp949.decodeString(response.body));
      final keys = rowList.first;
      final List<Map> list = rowList.skip(1).map((e) => Map.fromIterables(keys, e)).toList();
      List<String> part1List = [];
      Map<String, List<String>> resultMap = {};
      for (Map map in list) {
        String part1 = map['part1'].toString().trim();
        String part2 = map['part2'].toString().trim();
        part1List.add(part1);
        if (part1.isNotEmpty) {
          if (resultMap[part1] == null) {
            resultMap[part1] = [part2];
          } else {
            resultMap[part1]!.add(part2);
          }
        }
      }
      logger.d(resultMap);
      return resultMap;
    } else {
      return {};
    }
  }
}

enum Category {
  furniture,
  homeAppliance,
  book,
  stationery,
  pet,
  beauty,
  life,
  sports,
  food,
  toy,
  music,
  car,
  kitchen,
  kids,
  fashion;

  String get label {
    switch (this) {
      case Category.furniture:
        return '가구홈데코';
      case Category.homeAppliance:
        return '가전디지털';
      case Category.book:
        return '도서';
      case Category.stationery:
        return '문구오피스';
      case Category.pet:
        return '반려애완용품';
      case Category.beauty:
        return '뷰티';
      case Category.life:
        return '생활용품';
      case Category.sports:
        return '스포츠레져';
      case Category.food:
        return '식품';
      case Category.toy:
        return '완구취미';
      case Category.music:
        return '음반DVD';
      case Category.car:
        return '자동차용품';
      case Category.kitchen:
        return '주방용품';
      case Category.kids:
        return '출산유아동';
      case Category.fashion:
        return '패션의류잡화';
    }
  }

  String get url {
    switch (this) {
      case Category.toy:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-toy.csv?alt=media&token=48a0dc0b-0894-4053-bda4-4d9b8788ec48';
     case Category.furniture:
       return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-furniture.csv?alt=media&token=6240b585-0c74-4826-a591-312fd4949179';
      case Category.homeAppliance:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-homeappliance.csv?alt=media&token=88454ba7-9144-4ed5-82da-435895758caa';
      case Category.book:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-book.csv?alt=media&token=7d1f5c03-07b4-4006-8b83-6c726bce2dde';
      case Category.stationery:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-stationery.csv?alt=media&token=b48e3d91-7118-4e39-ac94-1ccd68619d9b';
      case Category.pet:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-pet.csv?alt=media&token=68fdbf7d-88cb-4e4f-858c-cd57c4e50ad9';
      case Category.beauty:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-beauty.csv?alt=media&token=bd6a5888-f2ba-4b7d-bcb9-af70b807ed13';
      case Category.life:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-life.csv?alt=media&token=c47b8eb7-9f44-403f-8883-ee1dc3d2491f';
      case Category.sports:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-sports.csv?alt=media&token=0ad47f19-5e9d-4ecb-92a9-22af8231b017';
      case Category.food:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-food.csv?alt=media&token=eacb0774-2eaa-4160-842f-65831225704e';
      case Category.music:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-music.csv?alt=media&token=8d32945a-bcc0-4280-a0de-c89cabe98954';
      case Category.car:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-car.csv?alt=media&token=a6cbc1e2-cdb8-426a-b31a-78301c8a48c2';
      case Category.kitchen:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-kitchen.csv?alt=media&token=0c12f0aa-24cd-4a3a-810b-71b9c22188a4';
      case Category.kids:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-kids.csv?alt=media&token=5464e003-cc4d-4b2e-97f0-568d99341290';
      case Category.fashion:
        return 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-fashion.csv?alt=media&token=ab40dc70-afde-4643-9ecc-3d0e9a4871e7';
    }
  }
}

