import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A page that serves as the home screen for the Dimo wallet application.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the device's width and height
    double deviceWidth = MediaQuery.sizeOf(context).width;
    double deviceHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.only(bottom: 50.h, left: 14.w, right: 14.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Main logo or icon of the wallet application
              Text(
                "D",
                style: TextStyle(fontSize: 160.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 100.h),
              // Description or tagline of the application
              Padding(
                padding: EdgeInsets.only(left: 32.w, right: 22.w, bottom: 8.h),
                child: Text(
                  "This is a Dimo wallet created by Abhi.codescode. Securely manage your digital assets with ease and experience a fast, user-friendly interface.",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              // Button to navigate to the create wallet page
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                height: 60.h,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the previous page or perform a specific action
                    Get.back(result: "popped");
                  },
                  child: Text(
                    "Create Wallet",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
