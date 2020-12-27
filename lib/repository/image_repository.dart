import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageRepository {
  Future<String> getImageBase64(String url) async {
    var response = await http.get(url);
    return base64.encode(response.bodyBytes);
  }
}
