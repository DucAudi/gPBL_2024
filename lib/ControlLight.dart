import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Screen_lock.dart';

class ControlLight extends StatefulWidget {
  const ControlLight({super.key});

  @override
  State<ControlLight> createState() => _ControlLightState();
}

class _ControlLightState extends State<ControlLight> {
  DatabaseReference ref1 =
      FirebaseDatabase.instance.ref("ControlLight/isRedOn");
  DatabaseReference ref2 =
      FirebaseDatabase.instance.ref("ControlLight/isGreenOn");
  DatabaseReference ref3 =
      FirebaseDatabase.instance.ref("ControlLight/isBlueOn");
  DatabaseReference ref4 =
      FirebaseDatabase.instance.ref("ControlLight/isBreathing");
  DatabaseReference ref5 =
      FirebaseDatabase.instance.ref("ControlLight/isFlashing");

  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;
  bool isSwitched5 = false;

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance.ref("/ControlLight");

    return StreamBuilder<DatabaseEvent>(
        stream: databaseReference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          final dynamic rawData = snapshot.data!.snapshot.value;

          if (rawData == null || rawData is! Map) {
            return const Text('Data is not available or invalid.');
          }

          bool isBlueOn = rawData['isBlueOn'];
          bool isRedOn = rawData['isRedOn'];
          bool isBreathing = rawData['isBreathing'];
          bool isFlashing = rawData['isFlashing'];
          bool isGreenOn = rawData['isGreenOn'];




          return Scaffold(
            appBar: AppBar(
              title: Text("Control Light"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate back to the Screen Lock page when the back button is pressed
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockScreen(),
                    ),
                  );
                },
              ),
            ),
            body: Column(
              children: [
                Image(image: AssetImage("assets/ElectricLightBg.png")),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Breathing"),
                        Switch(
                          value: isBreathing,
                          onChanged: (value) async {
                            if(value) {
                              databaseReference.update({"isRedOn": false,"isGreenOn": false,"isBlueOn": false,"isFlashing": false});
                            }
                            databaseReference.update({"isBreathing": value});
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Flashing"),
                        Switch(
                          value: isFlashing,
                          onChanged: (value) async {
                            if(value) {
                              databaseReference.update({"isRedOn": false,"isGreenOn": false,"isBlueOn": false,"isBreathing": false});
                            }
                            databaseReference.update({"isFlashing": value});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Red on"),
                        Switch(
                          value: isRedOn,
                          onChanged: (value) async {
                            databaseReference.update({"isRedOn": value});
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Blue on"),
                        Switch(
                          value: isBlueOn,
                          onChanged: (value) async {
                            databaseReference.update({"isBlueOn": value});
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Green on"),
                        Switch(
                          value: isGreenOn,
                          onChanged: (value) async {
                            databaseReference.update({"isGreenOn": value});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
