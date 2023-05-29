import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'screen_viewmodel.dart';

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

  static Future saveImageBytes(Uint8List bytes, String fileName) async {
    final image = await decodeImageFromList(bytes);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(const Offset(0, 0),
            Offset(image.width.toDouble(), image.height.toDouble())));

    canvas.drawImage(image, const Offset(0, 0), Paint());

    final paint = Paint()
      ..color = generateRandomColor().withOpacity(0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRect(
        Rect.fromLTWH(
            ScreenVM.originalCoordinates[0],
            ScreenVM.originalCoordinates[3],
            (ScreenVM.originalCoordinates[0] - ScreenVM.originalCoordinates[2]),
            (ScreenVM.originalCoordinates[1] -
                ScreenVM.originalCoordinates[3])),
        paint);

// End recording and obtain the image
    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    // Convert the image to bytes
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;
    final res = byteData.buffer.asUint8List();

    final blob = Blob([res], 'image/jpg');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement()
      ..href = url
      ..download = fileName;
    anchor.click();
    Url.revokeObjectUrl(url);
  }
}
