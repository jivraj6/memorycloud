import 'package:flutter/material.dart';
import 'package:memorycloud/screens/gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'sharedpref.dart';
import 'dart:js' as js;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Loginscreenstate createState() => Loginscreenstate();
}

class Loginscreenstate extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _pwaPromptAvailable = false;

  bool _obscurePassword = true;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPrompt();
    });
  }

  void _checkPrompt() {
    _pwaPromptAvailable =
        js.context.callMethod('isPwaPromptAvailable', []) as bool? ?? false;
    setState(() {
      _showInstallSnackBar(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _installPwa() async {
    final result = await js.context.callMethod('promptInstall', []);
    debugPrint('Install result: $result');

    // if (mounted) {
    //   setState(() {});
    // }
  }

  /// 🔹 Login API Call
  Future<void> loginUser() async {
    setState(() => isLoading = true);
    final url = Uri.parse("https://tempudo.com/memorycloud/login.php");

    try {
      final response = await http.post(
        url,
        body: {
          "mobile": mobileController.text,
          "password": passwordController.text,
        },
      );

      final data = jsonDecode(response.body);
      setState(() => isLoading = false);

      if (data["success"] == true) {
        final user = data["user"];
        await SharedPref.setUserId(user["id"].toString());
        await SharedPref.setUserMobile(user["mobile"].toString());
        await SharedPref.setUserName(user["name"].toString());

        // Fetch profile image from server

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Login failed"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(8),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showInstallSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text("Install the app to continue"),
      duration: const Duration(days: 1), // 👈 बहुत लंबा duration ताकि hide न हो
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "Install App",
        onPressed: () async {
          await _installPwa();
          ScaffoldMessenger.of(
            context,
          ).hideCurrentSnackBar(); // SnackBar बंद करना
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Installing...")));
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE4B5), Color.fromARGB(255, 247, 173, 173)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.05),

                      // Logo / Branding
                      Image.asset(
                        'assets/logo.png',
                        height: size.height * 0.08,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: size.height * 0.08),

                      // Mobile Field
                      _buildTextField(
                        label: 'Mobile Number',
                        controler: mobileController,
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {},
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Password Field
                      _buildTextField(
                        label: 'Password',
                        icon: Icons.lock,
                        controler: passwordController,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.brown.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        onChanged: (val) {},
                      ),
                      SizedBox(height: size.height * 0.01),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.brown.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : loginUser,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.red.shade300,
                            elevation: 5,
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: Color.fromARGB(255, 163, 127, 43),
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                        ],
                      ),
                      SizedBox(height: size.height * 0.025),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF2B2A29),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              color: const Color(0xFF2B2A29),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 TextField Builder
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controler,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controler,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100.withOpacity(0.8),
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown.shade700),
        prefixIcon: Icon(icon, color: Colors.brown.shade400),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown.shade200, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
      ),
    );
  }
}
