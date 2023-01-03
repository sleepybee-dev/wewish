import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:cp949_dart/cp949_dart.dart' as cp949;

class CategoryParser {

  static Future<Map<String, String>> getCategoryMap(String category) async {
    String url = "https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/category%2Fcategory-beauty.csv?alt=media&token=4df79eb9-ffff-4bb6-9f58-b71428d0dc27";
    Map<String, String> headers = {
      "responseType": "text/csv",
      // 'Content-Disposition': 'attachment;filename=/category-beauty.csv',
    };
    http.Response response = await http.get(Uri.parse(url),headers:headers);
    Logger logger = Logger(printer:PrettyPrinter());
    List<String> lines = response.body.split('\r\n');

    Reference reference = FirebaseStorage.instance.refFromURL("gs://wewish-b573a.appspot.com/category/category-beauty.csv");
    final data = await reference.getData();

    if (data != null) {
      List<List<dynamic>> rowList = const CsvToListConverter().convert(cp949.decodeString(response.body));
      final keys = rowList.first;
      final List<Map> list = rowList.skip(1).map((e) => Map.fromIterables(keys, e)).toList();
      List<String> part1List = [];
      for (Map map in list) {
        part1List.add(map['part1'].toString().trim());
      }
      logger.d(part1List.toSet().length);
    }
    return {};
  }

  static checkPart(String part) {

  }

}


const List<String> categories = [
  '가구홈데코',
  '가전디지털',
  '도서',
  '문구오피스',
  '반려애완용품',
  '뷰티',
  '생활용품',
  '스포츠레져',
  '식품',
  '완구취미',
  '음반DVD',
  '자동차용품',
  '주방용품',
  '출산유아동',
  '패션의류잡화'
];
