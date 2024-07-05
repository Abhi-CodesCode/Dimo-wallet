import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainNetWidget extends StatelessWidget {
  final Color color;
  final String name;

  const MainNetWidget({super.key, required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
          size: 10,
        ),
        SizedBox(
          width: 4.w,
        ),
        Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 15.sp),
        )
      ],
    );
  }
}
