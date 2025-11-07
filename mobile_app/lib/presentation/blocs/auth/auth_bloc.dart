import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart'; // ADD THIS

import '../../../core/services/user_service.dart'; // ✅ ADD THIS
import '../../../core/utils/app_logger.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable // ADD THIS
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService; // ✅ ADD THIS

  AuthBloc(this._firebaseAuth, this._userService) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithPhone>(_onLoginWithPhone);
    on<VerifyOtp>(_onVerifyOtp);
    on<LoginWithEmail>(_onLoginWithEmail);
    on<RegisterUser>(_onRegisterUser);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<DemoAutoLogin>(_onDemoAutoLogin);

    //_userService = UserService(); // ✅ ADD THIS
  }

  // Future<void> _onAuthCheckRequested(
  //     AuthCheckRequested event, Emitter<AuthState> emit) async {
  //   try {
  //     final user = _firebaseAuth.currentUser;
  //     if (user != null) {
  //       emit(AuthAuthenticated(
  //         userId: user.uid,
  //         userName: user.displayName ?? 'User',
  //         userEmail: user.email ?? '',
  //       ));
  //     } else {
  //       emit(AuthUnauthenticated());
  //     }
  //   } catch (e) {
  //     AppLogger.error('Error checking auth status', e);
  //     emit(AuthUnauthenticated());
  //   }
  // }
  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      // ✅ CHECK LOCAL STORAGE FIRST (Persistent login)
      if (_userService.isLoggedIn()) {
        final user = _userService.getCurrentUser()!;
        AppLogger.info('🔓 Auto-login from local storage: ${user.name}');

        emit(AuthAuthenticated(
          userId: user.userId,
          userName: user.name,
          userEmail: user.email ?? '',
        ));
        return;
      }

      // Check Firebase
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        // ✅ SAVE TO LOCAL for persistent login
        await _userService.saveUserFromFirebase(firebaseUser);

        emit(AuthAuthenticated(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'User',
          userEmail: firebaseUser.email ?? '',
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      AppLogger.error('Error checking auth status', e);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginWithPhone(
    LoginWithPhone event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${event.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(e.message ?? 'Verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(AuthOtpSent(
            verificationId: verificationId,
            phoneNumber: event.phoneNumber,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      AppLogger.error('Phone login error', e);
      emit(const AuthError('Failed to send OTP'));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // ✅ SAVE TO LOCAL DATABASE
        await _userService.saveUserFromFirebase(user);

        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
        ));
        AppLogger.info('✅ Phone login successful: ${user.phoneNumber}');
      } else {
        emit(const AuthError('Authentication failed'));
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('OTP verification error', e);

      String errorMessage = 'Invalid OTP. Please try again.';
      if (e.code == 'invalid-verification-code') {
        errorMessage = '❌ Invalid OTP code. Please check and try again.';
      } else if (e.code == 'session-expired') {
        errorMessage = '❌ OTP expired. Please request a new code.';
      }

      emit(AuthError(errorMessage));
    } catch (e) {
      AppLogger.error('OTP verification error', e);
      emit(const AuthError('Invalid OTP'));
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        // ✅ SAVE TO LOCAL DATABASE
        await _userService.saveUserFromFirebase(user);

        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
        ));
        AppLogger.info('✅ Email login successful: ${user.email}');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Email login error', e);

      String errorMessage = 'Invalid email or password';
      if (e.code == 'user-not-found') {
        errorMessage =
            '❌ No account found with this email. Please register first.';
      } else if (e.code == 'wrong-password') {
        errorMessage = '❌ Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '❌ Invalid email format.';
      } else if (e.code == 'user-disabled') {
        errorMessage = '❌ This account has been disabled.';
      }

      emit(AuthError(errorMessage));
    } catch (e) {
      AppLogger.error('Email login error', e);
      emit(const AuthError('Login failed. Please check your credentials.'));
    }
  }

  Future<void> _onRegisterUser(
    RegisterUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await userCredential.user?.updateDisplayName(event.name);
      final user = userCredential.user;

      if (user != null) {
        // ✅ SAVE TO LOCAL DATABASE
        await _userService.saveUserFromFirebase(user);

        emit(AuthAuthenticated(
          userId: user.uid,
          userName: event.name,
          userEmail: event.email,
        ));
        AppLogger.info(
            '✅ Registration successful: ${event.name} ${user.email}');
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Registration error', e);

      String errorMessage = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'email-already-in-use: This email is already registered. Please login instead.';
      } else if (e.code == 'weak-password') {
        errorMessage =
            'weak-password: Password is too weak. Use at least 6 characters.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'invalid-email: Invalid email format.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            'operation-not-allowed: Email/password registration is disabled.';
      }

      emit(AuthError(errorMessage));
    } catch (e) {
      AppLogger.error('Registration error', e);
      emit(const AuthError('Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // ✅ LOGOUT FROM LOCAL STORAGE FIRST
      await _userService.logout();

      // Then logout from Firebase
      await _firebaseAuth.signOut();

      emit(AuthUnauthenticated());
      AppLogger.info('🚪 User logged out successfully');
    } catch (e) {
      AppLogger.error('Logout error', e);
      emit(AuthUnauthenticated()); // Force logout anyway
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    add(AuthCheckRequested());
  }

  Future<void> _onDemoAutoLogin(
    DemoAutoLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Demo credentials
      const String demoEmail = 'demo@chiliguard.com';
      const String demoPassword = 'DemoChilli@2025';

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: demoEmail,
        password: demoPassword,
      );

      final user = userCredential.user;
      if (user != null) {
        // Save to local storage
        await _userService.saveUserFromFirebase(user);

        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'Demo Farmer',
          userEmail: user.email ?? demoEmail,
        ));

        AppLogger.info('✅ Demo auto-login successful: ${user.email}');
      } else {
        emit(const AuthError('Demo login failed'));
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Demo auto-login error', e);

      // If user doesn't exist, create it
      if (e.code == 'user-not-found') {
        try {
          const String demoEmail = 'demo@chiliguard.com';
          const String demoPassword = 'DemoChilli@2025';

          final userCredential =
              await _firebaseAuth.createUserWithEmailAndPassword(
            email: demoEmail,
            password: demoPassword,
          );

          await userCredential.user?.updateDisplayName('Demo Farmer');

          final user = userCredential.user;
          if (user != null) {
            await _userService.saveUserFromFirebase(user);

            emit(AuthAuthenticated(
              userId: user.uid,
              userName: 'Demo Farmer',
              userEmail: demoEmail,
            ));

            AppLogger.info('✅ Demo user created and logged in: ${user.email}');
            return;
          }
        } catch (createError) {
          AppLogger.error('Failed to create demo user', createError);
        }
      }

      emit(AuthError('Demo login failed: ${e.message}'));
    } catch (e) {
      AppLogger.error('Demo auto-login error', e);
      emit(const AuthError('Demo login failed'));
    }
  }
}
