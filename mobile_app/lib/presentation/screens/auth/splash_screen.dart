import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart'; // ⭐ ADD THIS - Need to import events
import '../../blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5)),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // // Check authentication status after animation
    // Future.delayed(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     _checkAuthStatus();
    //   }
    // });

    // ⭐⭐⭐ CHANGED: Trigger demo auto-login INSTEAD of checking auth status
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Trigger demo auto-login event on AuthBloc
        context.read<AuthBloc>().add(DemoAutoLogin());
      }
    });
  }

  // void _checkAuthStatus() {
  //   final authState = context.read<AuthBloc>().state;

  //   if (authState is AuthAuthenticated) {
  //     context.go('/');
  //   } else {
  //     context.go('/onboarding');
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ⭐⭐⭐ CHANGED: Use BlocListener to listen for auth state changes
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // When auth state changes, navigate accordingly
        if (state is AuthAuthenticated) {
          // ✅ Demo user logged in successfully → Go to home
          context.go('/');
        } else if (state is AuthError) {
          // ❌ Demo login failed → Show error and go to login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.go('/onboarding');
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Icon/Logo
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.eco,
                          size: 80,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // App Name
                      const Text(
                        'ChilliGuard',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tagline
                      Text(
                        'Smart Farming Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
