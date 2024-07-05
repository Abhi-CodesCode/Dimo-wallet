import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../apis/api_service.dart';
import '../main.dart';
import '../pages/send_token_page.dart';
import '../pages/login_page.dart';
import '../widgets/mainnet_widget.dart';

/// A page that displays the dashboard of the wallet application.
class DashboardPage extends StatefulWidget {
  final ApiService apiService;
  final String walletAddress;

  const DashboardPage({super.key, required this.apiService, required this.walletAddress});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  var totalAssetValue = 0.00;
  List<dynamic> tokens = [];
  List<dynamic> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Fetches data for the dashboard including balance and transaction history.
  Future<void> _fetchData() async {
    try {
      final response = await widget.apiService.fetchBalance();
      final responseActivity = await widget.apiService.fetchActivity();

      setState(() {
        totalAssetValue = response['total_asset_value'].toDouble();
        tokens = response['data'];
        transactions = responseActivity['data'];
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Shows an about dialog with information about the application.
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("About", style: TextStyle(fontSize: 18.sp)),
          content: Text("This is the Dimo wallet application created by Abhijeet ie abhi.codescode@gmail.com.", style: TextStyle(fontSize: 18.sp)),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Wallet",
                      style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10.w)),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.black26),
                          ),
                          onPressed: () {
                            showNotImplementedNotif(context);
                          },
                          child: const MainNetWidget(color: Colors.purple, name: "Polygon MainNet"),
                        ),
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          onSelected: (String value) {
                            switch (value) {
                              case 'About':
                                _showAboutDialog();
                                break;
                              case 'LogOut':
                                logOutState();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(apiService: widget.apiService)));
                                widget.apiService.authToken = null;
                                widget.apiService.walletAddress = null;
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {'About', 'LogOut'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14.sp),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF222322),
                  ),
                  height: 136.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Total Balance",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "\$ ${totalAssetValue.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24.sp),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160.w,
                            child: Text(
                              widget.walletAddress,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: widget.walletAddress));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Address copied to clipboard", style: TextStyle(fontSize: 14.sp)),
                                ),
                              );
                            },
                            child: Icon(Icons.copy_all, color: Colors.white, size: 14.w),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent[400]!),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendTokenPage(apiService: widget.apiService)));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0.h),
                          child: const Text(
                            "Send",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.lightBlue[400]!),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showNotImplementedNotif(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0.h),
                          child: const Text(
                            "Swap",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                const TabBar(
                  indicatorColor: Colors.white,
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(text: "Tokens"),
                    Tab(text: "Activity"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: _fetchData,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: ListView.builder(
                            itemCount: tokens.length,
                            itemBuilder: (context, index) {
                              final token = tokens[index];
                              return ListTile(
                                leading: Image.network(token['logo_url'], width: 30.w, height: 30.h),
                                title: Text(token['name']),
                                subtitle: Text(token['symbol']),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${token['display_balance']} ${token['symbol']}", style: TextStyle(fontSize: 16.sp)),
                                    Text("Value: \$${token['asset_value']}"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: _fetchData,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            final timeAgo = timeago.format(DateTime.parse(transaction['timestamp']));
                            String type = transaction['type'] == "send_token" ? "Sent" : "Received";
                            String sign = transaction['type'] == "send_token" ? '-' : '+';
                            String tokenSymbol = transaction['token']['symbol'];

                            return ListTile(
                              leading: Icon(type == "Sent" ? Icons.arrow_circle_up : Icons.arrow_circle_down),
                              title: Text('$type $tokenSymbol'),
                              subtitle: Text(timeAgo),
                              trailing: Text('$sign${transaction['metadata']['amount']}$tokenSymbol', style: TextStyle(fontSize: 14.sp)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays a notification indicating the feature is not implemented yet.
void showNotImplementedNotif(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("This feature is not implemented yet."),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed,
    ),
  );
}
