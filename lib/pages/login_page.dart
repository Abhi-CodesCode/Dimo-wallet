import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/api_service.dart';
import 'create_wallet_page.dart';
import 'dashboard_page.dart';
import 'package:Dimo_wallet/main.dart';

/// A page that handles user login for the wallet application.
class LoginPage extends StatefulWidget {
  final ApiService apiService;

  const LoginPage({super.key, required this.apiService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mixedController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isFilled = false;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    mixedController.addListener(() {
      setState(() {
        isFilled = mixedController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    mixedController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Handles user login by calling the API service.
  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.apiService.login(mixedController.text, passwordController.text);

      if (widget.apiService.authToken != null) {
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setBool(SplashPageState.KEYLOGIN, true);
        await sharedPref.setString(SplashPageState.FLIC_TOKEN, widget.apiService.authToken!);
        await sharedPref.setString(SplashPageState.WALLET_ADDRESS, widget.apiService.walletAddress!);
        await sharedPref.setBool(SplashPageState.FIRST, false);

        String walletAddress = widget.apiService.walletAddress!;
        Get.to(() => widget.apiService.hasWallet!
            ? DashboardPage(apiService: widget.apiService, walletAddress: walletAddress)
            : CreateWalletPage(apiService: widget.apiService));
      } else {
        setState(() {
          errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Align(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'D',
                      style: TextStyle(fontSize: 200.sp, fontFamily: "CupertinoSystemText"),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  TextField(
                    controller: mixedController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isFilled ? Colors.white30 : Colors.white12, width: 2.w),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30, width: 2.w),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      hintText: "eg: Kino Jackson",
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isFilled ? Colors.white30 : Colors.white12, width: 2.w),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30, width: 2.w),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.h),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.white10),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
