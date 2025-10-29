import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../widgets/auth/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterUser(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
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

          if (state is AuthAuthenticated) {
            context.go('/');
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
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    isHindi ? 'खाता बनाएं' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isHindi
                        ? 'शुरू करने के लिए अपना विवरण दर्ज करें'
                        : 'Enter your details to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Name field
                  AuthTextField(
                    controller: _nameController,
                    label: isHindi ? 'पूरा नाम' : 'Full Name',
                    hint: isHindi ? 'अपना नाम दर्ज करें' : 'Enter your name',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isHindi ? 'नाम दर्ज करें' : 'Enter name';
                      }
                      if (value.length < 3) {
                        return isHindi
                            ? 'नाम कम से कम 3 अक्षर का होना चाहिए'
                            : 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Phone field
                  AuthTextField(
                    controller: _phoneController,
                    label: isHindi ? 'फोन नंबर' : 'Phone Number',
                    hint: '9876543210',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
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

                  const SizedBox(height: 20),

                  // Email field
                  AuthTextField(
                    controller: _emailController,
                    label: isHindi ? 'ईमेल' : 'Email',
                    hint: 'farmer@example.com',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isHindi ? 'ईमेल दर्ज करें' : 'Enter email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return isHindi
                            ? 'मान्य ईमेल दर्ज करें'
                            : 'Enter valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  AuthTextField(
                    controller: _passwordController,
                    label: isHindi ? 'पासवर्ड' : 'Password',
                    hint: isHindi ? 'पासवर्ड दर्ज करें' : 'Enter password',
                    prefixIcon: Icons.lock,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isHindi ? 'पासवर्ड दर्ज करें' : 'Enter password';
                      }
                      if (value.length < 6) {
                        return isHindi
                            ? 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए'
                            : 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm password field
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label:
                        isHindi ? 'पासवर्ड की पुष्टि करें' : 'Confirm Password',
                    hint: isHindi
                        ? 'पासवर्ड फिर से दर्ज करें'
                        : 'Re-enter password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isHindi
                            ? 'पासवर्ड की पुष्टि करें'
                            : 'Confirm password';
                      }
                      if (value != _passwordController.text) {
                        return isHindi
                            ? 'पासवर्ड मेल नहीं खाते'
                            : 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
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
                              isHindi ? 'पंजीकरण करें' : 'Register',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isHindi
                            ? 'पहले से खाता है?'
                            : 'Already have an account?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          isHindi ? 'लॉगिन करें' : 'Login',
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
