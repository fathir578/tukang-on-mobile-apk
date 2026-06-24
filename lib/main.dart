import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/constants/api_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiConstants.init();
  runApp(const ProviderScope(child: TukangOnApp()));
}
