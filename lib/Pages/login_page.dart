import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_progress_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:pos/widgets/verfication_code_widget.dart';
import 'package:window_manager/window_manager.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final GetStorage storage = GetStorage();
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
              PosTextFormField(
                controller: passwordController,
                obscureText: true,
                hintText: 'Password',
              ),
              TextButton(
                onPressed: () {
                  Get.to(PasswordResetRequestPage());
                },
                child: const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              const SizedBox(height: 16.0),
              PosButton(
                text: 'Login',
                onPressed: () {
                  String password = storage.read(DBVal.password) ?? '';
                  if (passwordController.text == password) {
                    Get.off(const MainWindow());
                  } else {
                    AlertMessage.snakMessage('Invlid Password', context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    return true;
  }

  bool validatePassword(String password) {
    // Add your password validation logic here
    // For example, check if the password meets certain criteria
    return password.length >= 6;
  }
}

class PasswordResetRequestPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GetStorage storage = GetStorage();

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
              PosTextFormField(
                controller: emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              POSProgressButton(
                onPressed: () async {
                  if (validateEmail(emailController.text)) {
                    String code = generateCode();
                    bool isSent = await sendEmail(code, context);
                    if (isSent) {
                      storage.write(DBVal.resetPassword, code);
                      Get.to(ResetCodeCheckPage(emailController.text));
                    }
                  } else {
                    AlertMessage.snakMessage('Invalid Email', context);
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

  String generateCode() {
    // Generate a random 6-digit code
    return Random().nextInt(999999).toString().padLeft(6, '0');
  }

  bool validateEmail(String email) {
    return email.isNotEmpty;
  }

  Future<bool> sendEmail(String code, context) async {
    try {
      await EmailSender.sendEmail(emailController.text, context,
          title: 'Password Reset - POS',
          body: 'Your password reset code is $code');
      return true;
    } catch (e) {
      AlertMessage.snakMessage('Email Sent faild', context);
      return false;
    }
  }
}

class ResetCodeCheckPage extends StatelessWidget {
  final String userEmail;
  final TextEditingController codeController = TextEditingController();
  final GetStorage storage = GetStorage();
  final posButton = PosButton(text: 'Verify', onPressed: () {});
  ResetCodeCheckPage(this.userEmail, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: const Text(
          'Reset Code Check',
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
              const SizedBox(height: 16.0),
              VerificationCodeInput(
                length: 6,
                onCompleted: (String code) async {
                  codeController.text = code;
                  await verifyCode(context);
                },
              ),
              const SizedBox(height: 16.0),
              POSProgressButton(
                onPressed: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  await verifyCode(context);
                },
                text: 'Verify Code',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyCode(context) async {
    String storedCode = storage.read(DBVal.resetPassword);
    if (codeController.text == storedCode) {
      Get.to(PasswordResetPage());
    } else {
      AlertMessage.snakMessage('Invalid Code', context);
    }
  }
}

class PasswordResetPage extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final GetStorage storage = GetStorage();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PosTextFormField(
                controller: newPasswordController,
                hintText: 'New Password',
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              PosTextFormField(
                controller: confirmNewPasswordController,
                hintText: 'Confirm New Password',
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              POSProgressButton(
                onPressed: () async {
                  // Add your password reset logic here
                  if (newPasswordController.text ==
                      confirmNewPasswordController.text) {
                    storage.write(DBVal.password, newPasswordController.text);
                    AlertMessage.snakMessage(
                        'Password reset successfully', context);
                    await Future.delayed(const Duration(seconds: 2));
                    Get.offAll(LoginPage());
                  } else {
                    AlertMessage.snakMessage('Passwords do not match', context);
                  }
                },
                text: 'Reset Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
