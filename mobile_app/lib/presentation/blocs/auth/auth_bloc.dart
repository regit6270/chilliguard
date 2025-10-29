import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart'; // ADD THIS

import '../../../core/utils/app_logger.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable // ADD THIS
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithPhone>(_onLoginWithPhone);
    on<VerifyOtp>(_onVerifyOtp);
    on<LoginWithEmail>(_onLoginWithEmail);
    on<RegisterUser>(_onRegisterUser);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
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
        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
        ));
      } else {
        emit(const AuthError('Authentication failed'));
      }
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
        emit(AuthAuthenticated(
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userEmail: user.email ?? '',
        ));
      }
    } catch (e) {
      AppLogger.error('Email login error', e);
      emit(const AuthError('Invalid email or password'));
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
        emit(AuthAuthenticated(
          userId: user.uid,
          userName: event.name,
          userEmail: event.email,
        ));
      }
    } catch (e) {
      AppLogger.error('Registration error', e);
      emit(const AuthError('Registration failed'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _firebaseAuth.signOut();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    add(AuthCheckRequested());
  }
}
