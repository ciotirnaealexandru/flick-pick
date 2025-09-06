import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class PhoneFrameWrapper extends StatefulWidget {
  final Widget child;
  const PhoneFrameWrapper({super.key, required this.child});

  @override
  State<PhoneFrameWrapper> createState() => _PhoneFrameWrapperState();
}

class _PhoneFrameWrapperState extends State<PhoneFrameWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;

    if (isSmallScreen) {
      return widget.child;
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: const Color.fromARGB(255, 100, 81, 159),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.0,
                          child: Text(
                            "Flick Pick",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: constraints.minHeight / 10,
                              color: const Color.fromARGB(255, 5, 12, 28),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    DeviceFrame(
                      device: Devices.ios.iPhone16,
                      isFrameVisible: true,
                      screen: Builder(
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 7),
                            child: widget.child,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.minHeight / 7),
                        Text(
                          "Flick Pick",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: constraints.minHeight / 10,
                            color: const Color.fromARGB(255, 5, 12, 28),
                          ),
                        ),
                        Text(
                          "Your Next Binge,\nOne Tap Away.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: constraints.minHeight / 25,
                            color: const Color.fromARGB(255, 5, 12, 28),
                          ),
                        ),
                        SizedBox(height: constraints.minHeight / 20),
                        Text(
                          "Developed by\nAlexandru-Cosmin Ciotirnae",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: constraints.minHeight / 33,
                            color: const Color.fromARGB(255, 5, 12, 28),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
