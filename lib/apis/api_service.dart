import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.socialverseapp.com';
  String? authToken; // Stores the authentication token after login
  String? walletAddress; // Stores the wallet address associated with the user
  bool? hasWallet; // Indicates whether the user has a wallet

  /// Makes a POST request to login endpoint with [mixed] (username or email) and [password].
  /// Sets [authToken], [walletAddress], and [hasWallet] on successful login.
  Future<void> login(String mixed, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'mixed': mixed,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      authToken = data['token'];
      walletAddress = data['wallet_address'];
      hasWallet = data['has_wallet'];
      print('Login successful, token: $authToken');
    } else {
      print('Failed to login: ${response.reasonPhrase}');
      throw Exception('Failed to login');
    }
  }

  /// Creates a new wallet with [name] and [passCode] using the authenticated [authToken].
  Future<void> createWallet(String name, String passCode) async {
    if (authToken == null) {
      print('Auth token is null, please login first');
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/solana/wallet/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Flic-Token': '$authToken',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'passCode': passCode,
      }),
    );

    if (response.statusCode == 200) {
      print('Wallet created successfully');
    } else {
      print('Failed to create wallet: ${response.reasonPhrase}');
      throw Exception('Failed to create wallet');
    }
  }

  /// Transfers tokens to [recipient] on specified [network] from [from] address,
  /// with [amount], [userPin], [developerSecret], and [tokenAddress].
  Future<void> transferToken({
    required String recipient,
    required String network,
    required String from,
    required double amount,
    required String userPin,
    required String developerSecret,
    required String tokenAddress,
  }) async {
    final url = Uri.parse(
        '$baseUrl/mainnet/transfer-tokens?recipient=$recipient&network=$network&from=$from&amount=$amount&user_pin=$userPin&developer_secret=$developerSecret&token=$tokenAddress');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Flic-Token': '$authToken',
      },
    );

    if (response.statusCode == 200) {
      print('Transfer successful');
    } else {
      print('Failed to transfer token: ${response.statusCode} ${response.body}');
      throw Exception('Failed to transfer token');
    }
  }

  /// Fetches the wallet balance from the API.
  Future<Map<String, dynamic>> fetchBalance() async {
    if (authToken == null || walletAddress == null) {
      throw Exception('Auth token or wallet address is null, please login first');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/mainnet/wallet/balance?network=Polygon&wallet_address=$walletAddress'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Flic-Token': '$authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch balance: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  /// Fetches recent activities related to the wallet from the API.
  Future<Map<String, dynamic>> fetchActivity() async {
    if (authToken == null || walletAddress == null) {
      throw Exception('Auth token or wallet address is null, please login first');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/mainnet/activity?network=Polygon&wallet_address=$walletAddress'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Flic-Token': '$authToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch activity: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
