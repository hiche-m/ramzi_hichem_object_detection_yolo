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
  State<Screen> createState() => _ScreenState(cameras: cm);
}

class _ScreenState extends State<Screen> {
  final List<CameraDescription>? cameras;

  _ScreenState({required this.cameras});

  CameraController? controller;

  bool _isReady = true;
  bool detecting = false;
  bool buttonHold = false;

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
      return Text("Failed");
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Flash"),
                      Text("Settings"),
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
                              Expanded(
                                child: FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: 50.0,
                                  color: Colors.red,
                                ),
                              ),
                              LayoutBuilder(builder: (context, constraints) {
                                final double squareSize = min(
                                    constraints.maxWidth,
                                    constraints.maxHeight);
                                return GestureDetector(
                                  onTapDown: (details) => setState(() {
                                    buttonHold = true;
                                  }),
                                  onTapUp: (details) => setState(() {
                                    buttonHold = false;
                                  }),
                                  child: Container(
                                    height: squareSize - 20,
                                    width: squareSize - 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3.5),
                                    ),
                                    child: FractionallySizedBox(
                                      heightFactor: 0.9,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: CircleAvatar(
                                            backgroundColor: buttonHold
                                                ? Colors.grey
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              Expanded(
                                child: Text("Picture"),
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
