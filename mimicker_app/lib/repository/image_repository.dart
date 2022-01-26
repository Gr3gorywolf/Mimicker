import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageRepository {
  Future<String> getImageBase64(String url, {int scaleSize = -1}) async {
    var response = await http.get(Uri.parse(url));
    var imgBytes = response.bodyBytes;
    if (scaleSize > -1) {
      print("bf ->" + imgBytes.length.toString());
      var result = await FlutterImageCompress.compressWithList(
        imgBytes,
        minHeight: scaleSize,
        minWidth: scaleSize,
        quality: 25,
      );
      imgBytes = result;
      print("aft ->" + imgBytes.length.toString());
    }
    return base64.encode(imgBytes);
  }
}
