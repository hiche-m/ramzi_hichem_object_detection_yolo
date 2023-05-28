import 'package:flutter/material.dart';
import 'loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, // Customize cursor color
          selectionColor: Colors.grey, // Customize selection color
          selectionHandleColor:
              Colors.white, // Customize selection handle color
        ),
      ),
      home: const Loading(),
      debugShowCheckedModeBanner: false));
}
