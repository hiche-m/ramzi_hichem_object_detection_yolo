import 'dart:async';
import 'dart:math';

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

  static final StreamController<bool> _detectingController =
      StreamController<bool>.broadcast();

  static Stream<bool> get getDetecting => _detectingController.stream;

  static final StreamController<String> _labelController =
      StreamController<String>.broadcast();

  static Stream<String> get getLabel => _labelController.stream;

  static final StreamController<List<double>> _coordinatesController =
      StreamController<List<double>>.broadcast();

  static Stream<List<double>> get getCoordinates =>
      _coordinatesController.stream;

  static updateCoordinates() async {
    var random = Random();
    double threshold = 0.6;
    while (true) {
      double accuracy = random.nextDouble();
      await Future.delayed(const Duration(milliseconds: 900));
      _labelController
          .add(labels[(0 + random.nextDouble() * (25 - 0)).floor()]);
      _coordinatesController.add([
        10 + random.nextDouble() * (150 - 10),
        10 + random.nextDouble() * (150 - 10),
        250 + random.nextDouble() * (500 - 250),
        250 + random.nextDouble() * (700 - 250),
        accuracy
      ]);
      _detectingController.add(accuracy > threshold ? true : false);
    }
  }
}
