import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const ResponsiveWidget({
    required Key key,
    required this.largeScreen,
    required this.mediumScreen,
    required this.smallScreen,
  }) : super(key: key);

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1280;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 1280 &&
        MediaQuery.of(context).size.width >= 904;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 904;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (screenSize.width >= 1280) {
      return largeScreen;
    } else if (screenSize.width >= 904) {
      return mediumScreen;
    } else {
      return smallScreen;
    }
  }
}
