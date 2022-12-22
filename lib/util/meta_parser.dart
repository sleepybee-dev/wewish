import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:logger/logger.dart';

class MetaParser {
  static Future<OpengraphData> getOpenGraphData(String url) async {
    var uri = Uri.parse(url);
    var response = await http.get(uri);

    return OpengraphData.fromJson(getOpenGraphDataFromResponse(response));
  }

  static Map<String, dynamic> getOpenGraphDataFromResponse(
      http.Response response) {
    var requiredAttributes = ['title', 'image', 'description', 'url'];
    Map<String, dynamic> data = <String, dynamic>{};

    if (response.statusCode == 200) {
      var document = parser.parse(utf8.decode(response.bodyBytes));
      var openGraphMetaTags = _getOpenGraphData(document);

      for (var element in openGraphMetaTags) {
        if (element.attributes['property'] == null) {
          continue;
        }
        // ex) <meta property="og:title" content="타이틀" />
        var ogTagTitle = element.attributes['property']!.split(':').last;
        var ogTagValue = element.attributes['content'];

        if ((ogTagValue != null && ogTagValue.isNotEmpty) ||
            requiredAttributes.contains(ogTagTitle)) {
          if (ogTagValue == null || ogTagValue.isEmpty) {
            ogTagValue = _scrapeAlternateToEmptyValue(ogTagTitle, document);
          }
          data[ogTagTitle] = ogTagValue;
        }
      }
    }

    Logger().d(data);
    return data;
  }

  static String _scrapeAlternateToEmptyValue(
      String tagTitle, Document document) {
    if (tagTitle == "title") {
      return document.head == null
          ? '' : document.head!.getElementsByTagName("title")[0].text;
    }

    if (tagTitle == "image") {
      var images = document.body == null
          ? [] : document.body!.getElementsByTagName("img");
      if (images.isNotEmpty) {
        return images[0].attributes["src"] ?? '';
      }
      return "";
    }
    return "";
  }

  static List<Element> _getOpenGraphData(Document document) {
    return document.head == null
        ? []
        : document.head!.querySelectorAll("[property*='og:']");
  }
}

class OpengraphData {
  String title = '';
  String description = '';
  String image = '';
  String url = '';

  OpengraphData.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        description = json['description'] ?? '',
        image = json['image'] ?? '',
        url = json['url'] ?? '';
}
