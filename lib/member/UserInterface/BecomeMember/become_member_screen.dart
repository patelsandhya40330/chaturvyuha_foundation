import 'package:flutter/material.dart';
import 'package:chaturvyuha_foundation/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/member/utils/app_text_styles.dart';

class BecomeMemberScreen extends StatefulWidget {
  const BecomeMemberScreen({super.key});

  @override
  State<BecomeMemberScreen> createState() => _BecomeMemberScreenState();
}

class _BecomeMemberScreenState extends State<BecomeMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  // Toggle between Registration and Login mode
  bool _isLoginMode = false;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would call your Auth service here
      final String action = _isLoginMode ? 'Login' : 'Registration';

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('$action Demo Successful'),
          content: Text(
            'Hello ${_isLoginMode ? "" : _nameController.text}, your $action request was validated locally. '
            'Since this is a frontend prototype, no data was actually sent to a server.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _formKey.currentState?.reset(); // Reset validation errors when switching
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 64 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section
                        Text(
                          _isLoginMode ? 'LOGIN' : 'BECOME A MEMBER',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isLoginMode
                              ? 'Welcome Back to the Foundation'
                              : 'Join Our Global Community',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isLoginMode
                              ? 'Enter your credentials to access your profile and resources.'
                              : 'Create an account to track your progress, access exclusive resources, and stay connected.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),

                        // Form Container
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0DC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColor.primary.withAlpha(40),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name (Only for Registration)
                                if (!_isLoginMode) ...[
                                  _buildTextField(
                                    label: 'Full Name',
                                    controller: _nameController,
                                    icon: Icons.person_outline,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Please enter your name'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Email Address
                                _buildTextField(
                                  label: 'Email Address',
                                  controller: _emailController,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter your email';
                                    if (!v.contains('@'))
                                      return 'Please enter a valid email address';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Phone (Only for Registration)
                                if (!_isLoginMode) ...[
                                  _buildTextField(
                                    label: 'Phone Number',
                                    controller: _phoneController,
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Please enter phone number'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Password
                                _buildTextField(
                                  label: 'Password',
                                  controller: _passwordController,
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return 'Please enter password';
                                    if (v.length < 6)
                                      return 'Password must be at least 6 characters';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password (Only for Registration)
                                if (!_isLoginMode) ...[
                                  _buildTextField(
                                    label: 'Confirm Password',
                                    controller: _confirmPasswordController,
                                    icon: Icons.lock_reset,
                                    obscureText: true,
                                    validator: (v) {
                                      if (v != _passwordController.text)
                                        return 'Passwords do not match';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                ],

                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      _isLoginMode
                                          ? 'Login to Account'
                                          : 'Register as Member',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Toggle Mode Link
                                Center(
                                  child: TextButton(
                                    onPressed: _toggleMode,
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _isLoginMode
                                                ? "Don't have an account? "
                                                : "Already a member? ",
                                          ),
                                          TextSpan(
                                            text: _isLoginMode
                                                ? 'Register Now'
                                                : 'Login Here',
                                            style: const TextStyle(
                                              color: AppColor.primary,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColor.heading,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColor.primary, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.primary.withAlpha(50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.primary.withAlpha(30)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
