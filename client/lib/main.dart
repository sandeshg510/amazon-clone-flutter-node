import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/views/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MyApp(),
  );
}
