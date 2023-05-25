import 'package:flutter/material.dart';
import 'loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: Loading(), debugShowCheckedModeBanner: false));
}
