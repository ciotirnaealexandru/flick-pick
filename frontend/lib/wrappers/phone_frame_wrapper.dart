import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';

class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;

  const PhoneFrameWrapper({super.key, required this.child});

  @override
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 600;

    if (isSmallScreen) {
      return child;
    } else {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: const Color.fromARGB(255, 100, 81, 159),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Center(
                      child: DeviceFrame(
                        device: Devices.ios.iPhone16,
                        isFrameVisible: true,
                        screen: Builder(
                          builder: (context) {
                            final bottomInset =
                                MediaQuery.of(context).padding.bottom;
                            return Padding(
                              padding: EdgeInsets.only(bottom: bottomInset),
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),

                    Positioned(
                      left:
                          (constraints.maxWidth -
                                  Devices.ios.iPhone16.screenSize.width) /
                              2 +
                          Devices.ios.iPhone16.screenSize.width +
                          20,
                      top: 0,
                      child: Text(
                        "",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
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
