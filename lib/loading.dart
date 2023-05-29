import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:memoire/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen_viewmodel.dart';

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

  Future loadPrefs() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      ScreenVM.ip = prefs.getString("ip") ?? "0";
      ScreenVM.port = prefs.getString("port") ?? "0";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Text("Loading");
    }
    return Screen(cm: cameras);
  }
}
