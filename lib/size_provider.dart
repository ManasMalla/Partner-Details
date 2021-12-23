import 'package:flutter/material.dart';

class SizeProvider {
  static late double screenWidthFactor;
  static late double screenHeightFactor;
  static late Orientation orientation;
  void init(context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    orientation = mediaQueryData.orientation;
    Size screenSize = mediaQueryData.size;
    screenHeightFactor = screenSize.height / 2340;
    screenWidthFactor = screenSize.width / 1080;
  }
}

double getProportionalHeight(double height) {
  return SizeProvider.screenHeightFactor * height;
}

double getProportionalWidth(double width) {
  return SizeProvider.screenWidthFactor * width;
}
