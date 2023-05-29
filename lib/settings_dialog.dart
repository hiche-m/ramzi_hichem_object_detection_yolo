import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen_viewmodel.dart';

class Settings extends StatefulWidget {
  const Settings({required this.height, required this.width, super.key});
  final double height;
  final double width;
  @override
  State<Settings> createState() => _SettingsState();
}

var _formkey = GlobalKey<FormState>();

class _SettingsState extends State<Settings> {
  late final SharedPreferences prefs;

  late TextEditingController _ipController;
  late TextEditingController _portController;

  @override
  void initState() {
    init();
    _ipController = TextEditingController(text: ScreenVM.ip);
    _portController = TextEditingController(text: ScreenVM.port);
    super.initState();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      ScreenVM.ip = prefs.getString("ip") ?? "0";
      ScreenVM.port = prefs.getString("port") ?? "0";
    });
    _ipController.text = ScreenVM.ip;
    _portController.text = ScreenVM.port;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: widget.height * 0.3,
        width: widget.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: Colors.black.withOpacity(0.7),
        ),
        child: Column(
          children: [
            const Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Server Settings",
                        style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Form(
              key: _formkey,
              child: Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          const Expanded(
                            flex: 2,
                            child: FractionallySizedBox(
                              heightFactor: 0.7,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "IP Adress: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final double fontSize =
                                  constraints.maxHeight * 0.35;
                              return TextFormField(
                                controller: _ipController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: fontSize),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Ex: 192.168.10.12',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.3),
                                      fontSize: fontSize),
                                ),
                              );
                            }),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          const Expanded(
                            flex: 2,
                            child: FractionallySizedBox(
                              heightFactor: 0.3,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "Port: ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final double fontSize =
                                  constraints.maxHeight * 0.35;
                              return TextFormField(
                                controller: _portController,
                                style: TextStyle(
                                    color: Colors.white, fontSize: fontSize),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  hintText: 'Ex: 5000',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.3),
                                      fontSize: fontSize),
                                ),
                              );
                            }),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  child: Text(
                    "${ScreenVM.ip}:${ScreenVM.port}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FractionallySizedBox(
                    heightFactor: 0.75,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 0.75,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: TextButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            _formkey.currentState!.save();
                            setState(() {
                              ScreenVM.ip = _ipController.text;
                              ScreenVM.port = _portController.text;
                              prefs.setString("ip", ScreenVM.ip);
                              prefs.setString("port", ScreenVM.port);
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Connect",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
