// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vibration/flutter_vibration.dart';


void main() {
  
  test("test play", (){
    final _flutterVibrationPlugin = FlutterVibration();
    _flutterVibrationPlugin.play();
    Future.delayed(Duration(seconds: 5),(){
      _flutterVibrationPlugin.stop();
    });

  });

}
