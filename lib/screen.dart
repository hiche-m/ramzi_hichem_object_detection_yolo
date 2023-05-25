import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'screen_viewmodel.dart';

class Screen extends StatefulWidget {
  const Screen({required this.cm, super.key});

  final List<CameraDescription>? cm;

  @override
  // ignore: no_logic_in_create_state
  State<Screen> createState() => _ScreenState(cameras: cm);
}

class _ScreenState extends State<Screen> {
  final List<CameraDescription>? cameras;

  _ScreenState({required this.cameras});

  CameraController? controller;

  bool _isReady = true;
  bool detecting = false;
  bool buttonHold = false;
  bool video = false;
  bool capturing = false;
  bool pausedCapturing = false;

  double height = 0;
  double width = 0;
  List<double> coordinates = [0, 0, 0, 0, 0];

  String label = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    if (!kIsWeb) init();
  }

  void fetchData() {
    ScreenVM.updateCoordinates();
    ScreenVM.getDetecting.listen((value) {
      setState(() {
        detecting = value;
      });
    });
    ScreenVM.getCoordinates.listen((value) {
      setState(() {
        coordinates = value;
      });
    });
    ScreenVM.getLabel.listen((value) {
      setState(() {
        label = value;
      });
    });
  }

  void init() {
    setState(() {
      _isReady = false;
    });
    controller = CameraController(widget.cm![0], ResolutionPreset.medium);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isReady = true;
      });
    }).catchError((e) {
      setState(() {
        _isReady = false;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    height = MediaQuery.sizeOf(context).height;

    if (!_isReady) {
      return const Text("Failed");
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("fake_data.jpeg"), fit: BoxFit.cover),
            ),
          ),
          detecting
              ? Positioned(
                  left: coordinates[0],
                  top: coordinates[1],
                  child: SizedBox(
                    height: coordinates[3] - coordinates[1],
                    width: coordinates[2] - coordinates[0],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  label.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 25,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0))),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.9,
                                    heightFactor: 0.7,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "${(coordinates[4] * 100).round()}%",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 4.0,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              IconDataSolid(0xe0b7),
                              color: Colors.white,
                              semanticLabel: "Flashlight",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FaIcon(
                              IconDataSolid(0xf013),
                              color: Colors.white,
                              semanticLabel: "Settings",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 10, child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.75),
                          child: Row(
                            children: [
                              //Left Action
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.3,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.centerLeft,
                                      child: FaIcon(
                                        FontAwesomeIcons.photoFilm,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //Middle Acion
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  final double squareSize = min(
                                      constraints.maxWidth,
                                      constraints.maxHeight);
                                  return GestureDetector(
                                    onPanDown: (D) => setState(() {
                                      buttonHold = true;
                                    }),
                                    onPanCancel: () => setState(() {
                                      if (video) {
                                        capturing = !capturing;
                                        buttonHold = false;
                                      } else {
                                        if (capturing) {
                                          capturing = false;
                                        } else {
                                          buttonHold = false;
                                        }
                                      }
                                    }),
                                    onLongPressStart: !video
                                        ? (D) {
                                            setState(() {
                                              video = true;
                                              buttonHold = false;
                                              capturing = true;
                                            });
                                          }
                                        : (D) {},
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      height: squareSize - 20,
                                      width: squareSize - 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: capturing
                                                ? Colors.transparent
                                                : Colors.white,
                                            width: capturing ? 0 : 3.5),
                                      ),
                                      child: AnimatedFractionallySizedBox(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        heightFactor: capturing ? 1 : 0.9,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: CircleAvatar(
                                            backgroundColor: video
                                                ? buttonHold
                                                    ? Colors.redAccent[700]
                                                    : Colors.red
                                                : buttonHold
                                                    ? Colors.grey
                                                    : Colors.white,
                                            child: AnimatedScale(
                                              scale: capturing ? 1 : 0,
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              child: const Icon(
                                                Icons.stop,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              //Right Action
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (!capturing) {
                                          video = !video;
                                        } else {
                                          pausedCapturing = !pausedCapturing;
                                        }
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedFractionallySizedBox(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          heightFactor: !capturing ? 0 : 0.4,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              pausedCapturing
                                                  ? Icons.play_arrow_rounded
                                                  : Icons.pause,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        AnimatedFractionallySizedBox(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          heightFactor:
                                              capturing || video ? 0 : 0.3,
                                          child: const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.centerRight,
                                            child: FaIcon(
                                              IconDataSolid(0xf03d),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        AnimatedFractionallySizedBox(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          heightFactor:
                                              capturing || !video ? 0 : 0.3,
                                          child: const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            alignment: Alignment.centerRight,
                                            child: FaIcon(
                                              IconDataSolid(0xf083),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
