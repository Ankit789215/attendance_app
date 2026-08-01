import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/validators.dart';
import 'providers/auth_providers.dart';

/// Modern Material 3 login screen with glassmorphism and staggered animations.
///
/// Features:
///   • Gradient background
///   • Frosted-glass login card
///   • Email + password with real-time validation
///   • Obscure toggle for password
///   • Remember Me checkbox
///   • Forgot Password link
///   • No "Sign Up" (admin-only app)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authStateProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Listen to auth state changes for navigation & error handling.
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next is Authenticated) {
        context.go('/dashboard');
      } else if (next is AuthError) {
        SnackbarHelper.showError(context, next.message);
      }
    });

    final authState = ref.watch(authStateProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              Color(0xFF3730A3), // indigo-800
              Color(0xFF4F46E5), // indigo-600
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo ──────────────────────────────────
                    _buildLogo(context),
                    const SizedBox(height: 36),

                    // ── Glassmorphism Card ────────────────────
                    _buildLoginCard(context, isLoading, size),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Logo Section
  // -----------------------------------------------------------------------
  Widget _buildLogo(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 42,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.elasticOut,
            )
            .fade(duration: 300.ms),
        const SizedBox(height: 16),
        Text(
          'AttendEase',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
        )
            .animate(delay: 200.ms)
            .fade(duration: 400.ms)
            .slideY(begin: 0.2, end: 0),
        const SizedBox(height: 4),
        Text(
          'Welcome back, Admin',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ).animate(delay: 350.ms).fade(duration: 400.ms),
      ],
    );
  }

  // -----------------------------------------------------------------------
  // Glassmorphism Login Card
  // -----------------------------------------------------------------------
  Widget _buildLoginCard(BuildContext context, bool isLoading, Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section title
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter your credentials to continue',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 28),

                // Email
                _buildEmailField(),
                const SizedBox(height: 18),

                // Password
                _buildPasswordField(),
                const SizedBox(height: 14),

                // Remember Me + Forgot Password row
                _buildOptionsRow(context),
                const SizedBox(height: 24),

                // Login button
                _buildLoginButton(isLoading),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: 400.ms)
        .fade(duration: 500.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }

  // -----------------------------------------------------------------------
  // Email Field
  // -----------------------------------------------------------------------
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.validateEmail,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: _inputDecoration(
        label: 'Email',
        hint: 'admin@example.com',
        icon: Icons.email_outlined,
      ),
    ).animate(delay: 500.ms).fade(duration: 400.ms).slideX(begin: -0.05, end: 0);
  }

  // -----------------------------------------------------------------------
  // Password Field
  // -----------------------------------------------------------------------
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: Validators.validatePassword,
      onFieldSubmitted: (_) => _handleLogin(),
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: _inputDecoration(
        label: 'Password',
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    ).animate(delay: 600.ms).fade(duration: 400.ms).slideX(begin: -0.05, end: 0);
  }

  // -----------------------------------------------------------------------
  // Options Row (Remember Me / Forgot Password)
  // -----------------------------------------------------------------------
  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      children: [
        // Remember Me
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (v) => setState(() => _rememberMe = v ?? false),
            side: const BorderSide(color: Colors.white70, width: 1.5),
            checkColor: AppTheme.primaryColor,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.transparent;
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Text(
            'Remember me',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
          ),
        ),
        const Spacer(),

        // Forgot Password
        TextButton(
          onPressed: () => context.push('/forgot-password'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white.withValues(alpha: 0.5),
                ),
          ),
        ),
      ],
    ).animate(delay: 700.ms).fade(duration: 400.ms);
  }

  // -----------------------------------------------------------------------
  // Login Button
  // -----------------------------------------------------------------------
  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : _handleLogin,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.primaryColor,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.primaryColor.withValues(alpha: 0.7),
                ),
              )
            : const Text('Sign In'),
      ),
    ).animate(delay: 800.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  // -----------------------------------------------------------------------
  // Shared input decoration
  // -----------------------------------------------------------------------
  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white70, size: 20),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
      ),
      errorStyle: TextStyle(color: Colors.red.shade200),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
