import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'utils.dart';

class ScreenVM {
  static final List<String> labels = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];

  static final StreamController<Map> _coordinatesController =
      StreamController<Map>.broadcast();

  static Stream<Map> get getCoordinates => _coordinatesController.stream;

static List originalCoordinates = [];

  static updateCoordinates(
      VideoElement videoElement, List<double> screen) async {
    double threshold = 60;
    await Future.delayed(const Duration(milliseconds: 2000));
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      var frame = await ScreenVM.captureFrame(videoElement);
      var res = await predict(frame);
      Map map = jsonDecode(res);
      var coordinates = map["coordinates"] ?? [];
      originalCoordinates = coordinates;
      var ys = map["labels"] ?? [];

      if (coordinates.length > 0 && ys.length > 0) {
        if (coordinates.last.last * 100 < threshold) {
        } else {
          List newCords = scaledCordinates(
              coordinates[0].map((number) => number * 100).toList(), screen, [
            videoElement.videoHeight.toDouble(),
            videoElement.videoWidth.toDouble()
          ]);
          _coordinatesController
              .add({"coordinates": newCords, "label": labels[ys[0]]});
        }
      }
    }
  }

  static List scaledCordinates(
      List coordinates, List<double> screenSize, List<double> videoSize) {
    double scaleFactor = screenSize[0] / videoSize[0];
    double scaledWidth = videoSize[1] * scaleFactor;

    double xmin = coordinates[0];
    double ymin = coordinates[1];
    double xmax = coordinates[2];
    double ymax = coordinates[3];
    double accuracy = coordinates[4] / 100;

    double xMinPixel = xmin * scaledWidth / 100;
    double yMinPixel = ymin * screenSize[0] / 100;
    double xMaxPixel = xmax * scaledWidth / 100;
    double yMaxPixel = ymax * screenSize[0] / 100;

    double xOffset = (scaledWidth - screenSize[1]) / 2;
    double yOffset = (screenSize[0] - videoSize[0] * scaleFactor) / 2;

    double adjustedXMin = xMinPixel - xOffset;
    double adjustedYMin = yMinPixel - yOffset;
    double adjustedXMax = xMaxPixel - xOffset;
    double adjustedYMax = yMaxPixel - yOffset;

    if (adjustedXMin < 0) {
      adjustedXMin = 1;
    }
    if (adjustedXMin > screenSize[1]) {
      adjustedXMin = screenSize[1];
    }

    if (adjustedYMin < 0) {
      adjustedYMin = 1;
    }
    if (adjustedYMin > screenSize[0]) {
      adjustedYMin = screenSize[0];
    }

    if (adjustedXMax < 0) {
      adjustedXMax = 1;
    }
    if (adjustedXMax > screenSize[1]) {
      adjustedXMax = screenSize[1];
    }

    if (adjustedYMax < 0) {
      adjustedYMax = 1;
    }
    if (adjustedYMax > screenSize[0]) {
      adjustedYMax = screenSize[0];
    }
    return [adjustedXMin, adjustedYMin, adjustedXMax, adjustedYMax, accuracy];
  }

  static Future predict(imageBytes) async {
    final url = Uri.parse('http://127.0.0.1:4500/predict');

    // Create the multipart request
    final request = http.MultipartRequest('POST', url);

    // Add the image file to the request
    request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
        filename: 'image.jpg'));

    // Send the request and get the response
    final response = await http.Response.fromStream(await request.send());

    return response.body;
  }

  static Future<Uint8List> captureFrame(VideoElement videoElement) async {
    // Create a canvas element with the same dimensions as the video
    CanvasElement canvasElement = CanvasElement(
      width: videoElement.videoWidth,
      height: videoElement.videoHeight,
    );

    // Draw the current frame of the video onto the canvas
    canvasElement.context2D.drawImage(videoElement, 0, 0);

    // Get the data URL of the canvas image
    String imageDataUrl = canvasElement.toDataUrl('image/jpg');

    Uint8List data = await Utils.createImageFromDataUrl(imageDataUrl);

    return data;
  }
}
