import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressImage {
  static Future<Uint8List> startCompress(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(list);
    return result;
  }
}
