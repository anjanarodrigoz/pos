import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/login_page.dart';
import 'package:pos/services/auth_service.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/validators.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';

/// Initial setup page for first-time password creation
class InitialSetupPage extends StatefulWidget {
  const InitialSetupPage({super.key});

  @override
  State<InitialSetupPage> createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PasswordStrength? passwordStrength;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security,
                    size: 64,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Welcome to POS System',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Set up your admin password',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32.0),

                  // Password field
                  SizedBox(
                    width: 400,
                    child: PosTextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      hintText: 'Create Password',
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          passwordStrength = Validators.validatePassword(value);
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        final strength = Validators.validatePassword(value);
                        if (!strength.isValid) {
                          return strength.message;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Password strength indicator
                  if (passwordStrength != null && passwordController.text.isNotEmpty)
                    SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: passwordStrength!.percentage / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              passwordStrength!.strength >= 4
                                  ? Colors.green
                                  : passwordStrength!.strength >= 3
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            passwordStrength!.message,
                            style: TextStyle(
                              fontSize: 12,
                              color: passwordStrength!.isValid
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16.0),

                  // Confirm password field
                  SizedBox(
                    width: 400,
                    child: PosTextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirm,
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Password requirements
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password Requirements:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        _buildRequirement('At least 8 characters'),
                        _buildRequirement('Uppercase and lowercase letters'),
                        _buildRequirement('At least one number'),
                        _buildRequirement('Not a common password'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Create button
                  SizedBox(
                    width: 400,
                    child: PosButton(
                      text: 'Create Password & Continue',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Set password using secure auth service
                            await AuthService.setPassword(passwordController.text);

                            AppLogger.info('Initial password setup completed');

                            if (context.mounted) {
                              AlertMessage.snakMessage(
                                'Password created successfully!',
                                context,
                              );

                              // Navigate to login page
                              Get.off(() => LoginPage());
                            }
                          } catch (e) {
                            AppLogger.error('Failed to set password', e);
                            if (context.mounted) {
                              AlertMessage.snakMessage(
                                'Error: ${e.toString()}',
                                context,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.blue),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
