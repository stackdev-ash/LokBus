import 'package:flutter/material.dart';
import 'package:lokbus_clean/pages/homepage.dart';
import 'package:lokbus_clean/pages/sign_up.dart';
import 'package:lokbus_clean/pages/driver_home.dart';
import 'package:lokbus_clean/pages/authority_home.dart';
import 'package:lokbus_clean/services/api_service.dart';
import 'package:lokbus_clean/utils/storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _loading = false;

  // ✅ Password visibility toggle
  bool _obscurePassword = true;

  Future<void> _doLogin() async {
    final phone = _phoneCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter phone and password")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await ApiService.login(phone, password);
      debugPrint("LOGIN RESPONSE: $res");

      if (!mounted) return;

      if (res['token'] != null && res['user'] != null) {
        final role = res['user']['role'] ?? "user";

        // ✅ Store token + role
        await SecureStorage.writeToken(res['token']);
        await SecureStorage.writeRole(role);

        // ✅ Navigate based on role
        Widget nextPage;
        if (role == "driver") {
          nextPage = const DriverHome();
        } else if (role == "admin") {
          nextPage = const AuthorityHome();
        } else {
          nextPage = const HomePage();
        }

        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => nextPage));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid login credentials")),
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/LokBus4.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D261C),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sign in to your LokBus account',
                  style: TextStyle(fontSize: 16, color: Color(0xFFA9A9A9)),
                ),
                const SizedBox(height: 20),

                // Phone input
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // ✅ Password input with toggle
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C1E1D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _loading ? null : _doLogin,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Sign In"),
                  ),
                ),
                const SizedBox(height: 12),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF8C1E1D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
