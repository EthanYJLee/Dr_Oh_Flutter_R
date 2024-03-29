import 'package:dr_oh_app/components/color_service.dart';
import 'package:dr_oh_app/view/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'binding/init_bindings.dart';
import 'firebase_options.dart';

void main() async {
  // Date: 2023-01-09, jyh
  // firebase 연동
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'DrOh',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Firebase.app();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // Date: 2023-01-07, SangwonKim
        // 프라이머리 스와치 컬러 : figma > primary-진하게 > colorcode: 5B9D46
        // Update Date: 2023-01-08, SangwonKim
        // color code 변경: primary > 99CD89
        primarySwatch: ColorService.createMaterialColor(Color(0xffAACB73)),
        primaryColorDark: Color(0xffAACB73),
        primaryColorLight: Color(0xffAACB73),
        scaffoldBackgroundColor: Color(0xffE5E0FF),
        // Date: 2023-01-07, SangwonKim
        // Desc: app바 테마 설정
        appBarTheme: AppBarTheme(
          color: Colors.grey[50],
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData.dark(),
      initialBinding: InitBinding(),
      home: const Login(),
    );
  }
}
