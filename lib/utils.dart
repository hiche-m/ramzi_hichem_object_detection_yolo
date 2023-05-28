import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:html';
import 'package:flutter/material.dart';

class Utils {
  static Future<Uint8List> createImageFromDataUrl(String imageDataUrl) async {
    // Convert the data URL to bytes
    String base64 = imageDataUrl.split(',')[1];
    Uint8List bytes = base64Decode(base64);

    return bytes;
  }

  static Color generateRandomColor() {
    final random = Random();

    // Generate random hue value between 0 and 360
    final hue = random.nextInt(360);

    // Generate a random saturation and value
    final saturation = random.nextDouble();
    final value = random.nextDouble();

    // Create a Color object with the generated HSV values
    final color =
        HSVColor.fromAHSV(1.0, hue.toDouble(), saturation, value).toColor();

    return color;
  }

  static void saveImageBytes(Uint8List bytes, String fileName) {
    final blob = Blob([bytes], 'image/jpg');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement()
      ..href = url
      ..download = fileName;
    anchor.click();
    Url.revokeObjectUrl(url);
  }
}
