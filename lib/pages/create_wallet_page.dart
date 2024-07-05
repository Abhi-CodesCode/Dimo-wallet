import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../apis/api_service.dart';
import '../controllers/navigation_controller.dart';
import 'dashboard_page.dart';

/// A page for creating a new wallet in the Dimo wallet application.
class CreateWalletPage extends StatefulWidget {
  final ApiService apiService;

  const CreateWalletPage({super.key, required this.apiService});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  final NavigationController navigationController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passCodeController = TextEditingController();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the name input field to update the UI
    nameController.addListener(() {
      setState(() {
        isFilled = nameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    passCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create Wallet', style: TextStyle(color: Colors.white70)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            const Text(
              "Name",
              style: TextStyle(color: Colors.white38, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: TextField(
                style: const TextStyle(color: Colors.white60),
                controller: nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isFilled ? Colors.white30 : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white30, width: 2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  hintText: "eg: Kino Jackson",
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            const Text(
              "Pass Code",
              style: TextStyle(color: Colors.white38),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
              child: PinCodeTextField(
                controller: passCodeController,
                textStyle: const TextStyle(color: Colors.white24),
                appContext: context,
                length: 6,
                pinTheme: PinTheme(
                  activeColor: Colors.white54,
                  inactiveColor: Colors.white30,
                  selectedColor: Colors.white54,
                  fieldHeight: 50.h,
                  fieldWidth: 42.w,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.r),
                  fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 0),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
              height: 60.h,
              width: 400.w,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                onPressed: () async {
                  // Get the wallet address and create a wallet
                  String walletAddress = widget.apiService.walletAddress!;
                  await widget.apiService.createWallet(
                    nameController.text,
                    passCodeController.text,
                  );

                  // Navigate to the dashboard page after creating the wallet
                  navigationController.navigateToNewPage(
                    DashboardPage(
                      apiService: widget.apiService,
                      walletAddress: walletAddress,
                    ),
                  );
                },
                child: const Text("Create Wallet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
