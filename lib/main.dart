import 'dart:async';

import 'package:Dimo_wallet/apis/api_service.dart';
import 'package:Dimo_wallet/controllers/navigation_controller.dart';
import 'package:Dimo_wallet/pages/dashboard_page.dart';
import 'package:Dimo_wallet/pages/home_page.dart';
import 'package:Dimo_wallet/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The entry point of the application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

/// Logs out the user by setting the login state to false in shared preferences.
Future<void> logOutState() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  sharedPref.setBool(SplashPageState.KEYLOGIN, false);
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) => GetMaterialApp(
        initialBinding: BindingsBuilder(() {
          Get.lazyPut<NavigationController>(() => NavigationController());
        }),
        debugShowCheckedModeBanner: false,
        title: 'Dimo Wallet',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        home: child,
      ),
      designSize: const Size(412, 892),
      child: const SplashPage(),
    );
  }
}

/// The splash screen widget that displays initially.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final ApiService apiService = ApiService();

  /// Key for storing login state in shared preferences.
  static const String KEYLOGIN = "Login";

  /// Key for storing token in shared preferences.
  static const String FLIC_TOKEN = "token";

  /// Key for storing wallet address in shared preferences.
  static const String WALLET_ADDRESS = "address";

  /// Key for storing first-time flag in shared preferences.
  static const String FIRST = "first";

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        child: Center(
          child: Text(
            "D",
            style: TextStyle(fontSize: 72.spMax),
          ),
        ),
      ),
    );
  }

  /// Determines where to navigate after the splash screen based on the login state and other flags.
  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    var token = sharedPref.getString(FLIC_TOKEN);
    var walletAddress = sharedPref.getString(WALLET_ADDRESS);
    var firstTime = sharedPref.getBool(FIRST);

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn == true) {
        apiService.authToken = token;
        apiService.walletAddress = walletAddress;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardPage(
                  apiService: apiService,
                  walletAddress: walletAddress!,
                )));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(apiService: apiService)));
      }

      if (firstTime == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }
}
