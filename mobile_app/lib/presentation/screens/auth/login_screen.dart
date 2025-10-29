import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/auth/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      context.read<AuthBloc>().add(LoginWithPhone(phone));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is AuthOtpSent) {
            context.push('/phone-verification', extra: {
              'verificationId': state.verificationId,
              'phoneNumber': state.phoneNumber,
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/onboarding'),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    isHindi ? 'स्वागत है' : 'Welcome Back',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isHindi
                        ? 'जारी रखने के लिए अपना फोन नंबर दर्ज करें'
                        : 'Enter your phone number to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Phone number input
                  AuthTextField(
                    controller: _phoneController,
                    label: isHindi ? 'फोन नंबर' : 'Phone Number',
                    hint: '9876543210',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isHindi
                            ? 'फोन नंबर दर्ज करें'
                            : 'Enter phone number';
                      }
                      if (value.length != 10) {
                        return isHindi
                            ? 'मान्य फोन नंबर दर्ज करें'
                            : 'Enter valid phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isHindi ? 'OTP भेजें' : 'Send OTP',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isHindi ? 'नया उपयोगकर्ता?' : 'New user?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: Text(
                          isHindi ? 'पंजीकरण करें' : 'Register',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
