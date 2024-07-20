import 'package:flutter/material.dart';
import 'package:living_way/app.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(const LivingWayApp());
}
