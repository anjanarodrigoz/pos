import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/services/auth_service.dart';
import 'package:pos/services/verification_service.dart';
import 'package:pos/services/backup_encryption_service.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/validators.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_progress_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:pos/widgets/verfication_code_widget.dart';
import 'package:window_manager/window_manager.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows || Platform.isMacOS) {
      WindowOptions windowOptions = const WindowOptions(
        size: Size(500, 400),
        center: true,
        skipTaskbar: false,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'POS System',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32.0),
              PosTextFormField(
                controller: passwordController,
                obscureText: true,
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => PasswordResetRequestPage());
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              const SizedBox(height: 16.0),
              PosButton(
                text: 'Login',
                onPressed: () async {
                  final password = passwordController.text;

                  if (password.isEmpty) {
                    AlertMessage.snakMessage('Please enter password', context);
                    return;
                  }

                  // Verify password using secure auth service
                  final isValid = await AuthService.verifyPassword(password);

                  if (isValid) {
                    // Initialize backup encryption with user password
                    await BackupEncryptionService.initializeBackupKey(password);

                    AppLogger.info('User logged in successfully');
                    Get.off(() => const MainWindow());
                  } else {
                    AppLogger.warning('Failed login attempt');
                    AlertMessage.snakMessage('Invalid Password', context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordResetRequestPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  PasswordResetRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(
          'Password Reset Request',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Enter your email address to receive a reset code'),
              const SizedBox(height: 20.0),
              PosTextFormField(
                controller: emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16.0),
              POSProgressButton(
                onPressed: () async {
                  final email = emailController.text.trim();

                  // Validate email
                  if (!Validators.validateEmail(email)) {
                    AlertMessage.snakMessage(
                        'Please enter a valid email address', context);
                    return;
                  }

                  // Generate secure verification code
                  final code = VerificationService.generateSecureCode();

                  // Store code with metadata
                  await VerificationService.storeCode(
                    code: code,
                    email: email,
                  );

                  // Send email
                  final isSent = await _sendEmail(code, email, context);

                  if (isSent) {
                    AppLogger.info('Password reset code sent to $email');
                    Get.to(() => ResetCodeCheckPage(email));
                  }
                },
                text: 'Send Code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _sendEmail(String code, String email, context) async {
    try {
      await EmailSender.sendEmail(
        email,
        context,
        title: 'Password Reset - POS',
        body: 'Your password reset code is: $code\n\n'
            'This code will expire in 10 minutes.\n'
            'If you did not request this reset, please ignore this email.',
      );
      return true;
    } catch (e) {
      AppLogger.error('Failed to send reset email', e);
      AlertMessage.snakMessage('Failed to send email', context);
      return false;
    }
  }
}

class ResetCodeCheckPage extends StatelessWidget {
  final String userEmail;
  final TextEditingController codeController = TextEditingController();

  ResetCodeCheckPage(this.userEmail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(
          'Reset Code Verification',
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Enter the reset code sent to $userEmail'),
              const SizedBox(height: 8.0),
              const Text(
                'Code expires in 10 minutes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24.0),
              VerificationCodeInput(
                length: 6,
                onCompleted: (String code) async {
                  codeController.text = code;
                  await _verifyCode(context);
                },
              ),
              const SizedBox(height: 16.0),
              POSProgressButton(
                onPressed: () async {
                  await _verifyCode(context);
                },
                text: 'Verify Code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyCode(context) async {
    if (codeController.text.isEmpty) {
      AlertMessage.snakMessage('Please enter the verification code', context);
      return;
    }

    // Use verification service
    final result = await VerificationService.verifyCode(
      inputCode: codeController.text,
      email: userEmail,
    );

    if (result.success) {
      AppLogger.info('Verification code validated for $userEmail');
      Get.to(() => PasswordResetPage());
    } else {
      AppLogger.warning('Invalid verification code attempt for $userEmail');
      AlertMessage.snakMessage(result.message, context);
    }
  }
}

class PasswordResetPage extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final RxString passwordStrengthMessage = ''.obs;
  final RxDouble passwordStrengthValue = 0.0.obs;
  final RxBool showStrength = false.obs;

  PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(
          'Password Reset',
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Create a strong password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Must be at least 8 characters with uppercase, lowercase, and numbers',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                PosTextFormField(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  onChanged: (value) {
                    _checkPasswordStrength(value);
                  },
                ),
                const SizedBox(height: 8.0),
                Obx(() {
                  if (!showStrength.value) return const SizedBox.shrink();

                  return Column(
                    children: [
                      LinearProgressIndicator(
                        value: passwordStrengthValue.value,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getStrengthColor(passwordStrengthValue.value),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        passwordStrengthMessage.value,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStrengthColor(passwordStrengthValue.value),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16.0),
                PosTextFormField(
                  controller: confirmNewPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                const SizedBox(height: 24.0),
                POSProgressButton(
                  onPressed: () async {
                    await _resetPassword(context);
                  },
                  text: 'Reset Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      showStrength.value = false;
      return;
    }

    showStrength.value = true;
    final strength = Validators.validatePassword(password);
    passwordStrengthMessage.value = strength.message;
    passwordStrengthValue.value = strength.percentage / 100;
  }

  Color _getStrengthColor(double strength) {
    if (strength < 0.4) return Colors.red;
    if (strength < 0.6) return Colors.orange;
    if (strength < 0.8) return Colors.yellow[700]!;
    return Colors.green;
  }

  Future<void> _resetPassword(BuildContext context) async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmNewPasswordController.text;

    // Check if passwords match
    if (newPass != confirmPass) {
      AlertMessage.snakMessage('Passwords do not match', context);
      return;
    }

    // Check if password is common
    if (Validators.isCommonPassword(newPass)) {
      AlertMessage.snakMessage(
          'Password is too common. Please choose a stronger password.', context);
      return;
    }

    // Validate password strength
    final validation = Validators.validatePassword(newPass);
    if (!validation.isValid) {
      AlertMessage.snakMessage(validation.message, context);
      return;
    }

    try {
      // Set new password using secure auth service
      await AuthService.setPassword(newPass);

      // Initialize backup encryption with new password
      await BackupEncryptionService.initializeBackupKey(newPass);

      AppLogger.info('Password reset successfully');
      AlertMessage.snakMessage('Password reset successfully', context);

      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => LoginPage());
    } catch (e) {
      AppLogger.error('Password reset failed', e);
      AlertMessage.snakMessage('Failed to reset password', context);
    }
  }
}
