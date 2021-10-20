import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

abstract class HttpUtils {
  static Future<Uint8List> downloadFile(String url) async {
    final http = HttpClient();

    final request = await http.getUrl(Uri.parse(url));

    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception(
          "HttpUtils.downloadFile($url): got status ${response.statusCode}");
    }

    return consolidateHttpClientResponseBytes(response);
  }
}
