import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({required this.height, required this.width, super.key});
  final double height;
  final double width;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            Expanded(
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
            Expanded(
              flex: 5,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.75,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "IP Adress: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "192.168.12.11",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Port: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "5000",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
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
                    "192.168.12.11:5000",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
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
                        child: Text(
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Save",
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
