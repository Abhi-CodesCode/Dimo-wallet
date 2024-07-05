import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../apis/api_service.dart';

class SendTokenPage extends StatefulWidget {
  final ApiService apiService;

  const SendTokenPage({super.key, required this.apiService});

  @override
  SendTokenPageState createState() => SendTokenPageState();
}

class SendTokenPageState extends State<SendTokenPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();

    // Listen for changes in address and amount controllers to update the UI
    addressController.addListener(updateFilledState);
    amountController.addListener(updateFilledState);
  }

  void updateFilledState() {
    setState(() {
      // Update isFilled state based on whether both address and amount are filled
      isFilled = addressController.text.isNotEmpty &&
          amountController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    addressController.dispose();
    amountController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Send Tokens', style: TextStyle(color: Colors.white70)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Recipient Address",
                  style: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              TextField(
                style: const TextStyle(color: Colors.white60),
                controller: addressController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30, width: 2.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30, width: 2.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  hintText: "Enter recipient address",
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
              SizedBox(height: 24.h),
              const Text("Amount",
                  style: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w600)),
              SizedBox(height: 12.h),
              TextField(
                style: const TextStyle(color: Colors.white60),
                controller: amountController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30, width: 2.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30, width: 2.w),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  hintText: "Enter amount",
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
              SizedBox(height: 24.h),
              const Text("Pass Code",
                  style: TextStyle(
                      color: Colors.white38, fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                child: PinCodeTextField(
                  controller: pinCodeController,
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
                    fieldOuterPadding:
                    const EdgeInsets.symmetric(horizontal: 0),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 14.h)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r))),
                  ),
                  onPressed: isFilled
                      ? () {
                    // Handle send token logic here
                    widget.apiService.transferToken(
                      recipient: addressController.text,
                      network: 'Polygon',
                      from: widget.apiService.walletAddress!,
                      amount: double.parse(amountController.text),
                      userPin: pinCodeController.text,
                      developerSecret: 'testnet-secret',
                      tokenAddress:
                      '0xec05f9eb5ebc36732256bc86eaf654c55a20752a',
                    );
                    print(
                        'Send token to ${addressController.text} with amount ${amountController.text}');
                  }
                      : null,
                  child: const Text("Send Tokens",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
