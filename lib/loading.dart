import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:memoire/screen.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  static bool loading = true;

  static List<CameraDescription>? cameras;

  @override
  void initState() {
    loadCameras();
    super.initState();
  }

  Future loadCameras() async {
    if (kIsWeb) {
      setState(() {
        loading = false;
      });
    } else {
      cameras = await availableCameras();
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Text("Loading");
    }
    return Screen(cm: cameras);
  }
}
