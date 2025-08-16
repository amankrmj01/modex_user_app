import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (state is AuthFailure) {
              _showSnack(context, state.error, Colors.red.shade400);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) return const _LoadingOverlay();
            return _LoginForm(
              emailController: _emailController,
              passwordController: _passwordController,
            );
          },
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.9 * 255).toInt()),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF667eea)),
            ),
            const SizedBox(height: 16),
            Text(
              'Signing you in...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginForm({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Logo(),
                const SizedBox(height: 24),
                _WelcomeText(),
                const SizedBox(height: 32),
                _EmailField(controller: emailController),
                const SizedBox(height: 20),
                _PasswordField(controller: passwordController),
                const SizedBox(height: 12),
                _ForgotPasswordButton(),
                const SizedBox(height: 24),
                _LoginButton(
                  emailController: emailController,
                  passwordController: passwordController,
                ),
                const SizedBox(height: 24),
                _DividerWidget(),
                const SizedBox(height: 24),
                _SocialButtons(),
                const SizedBox(height: 24),
                _SignupLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withAlpha((0.3 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 40),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to ModEx',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _InputWrapper(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: _inputDecoration(
          label: 'Email Address',
          icon: Icons.email_outlined,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _InputWrapper(
      child: TextField(
        controller: controller,
        obscureText: true,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: _inputDecoration(
          label: 'Password',
          icon: Icons.lock_outline,
        ),
      ),
    );
  }
}

class _InputWrapper extends StatelessWidget {
  final Widget child;

  const _InputWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Icon(icon, color: Colors.grey.shade600),
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Forgot password
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF667eea),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withAlpha((0.4 * 255).toInt()),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthBloc>().add(
            LoginRequested(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Sign In',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SocialButton(
            label: 'Facebook',
            icon: Icons.facebook,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement social login
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => SignupScreen()));
          },
          child: Text(
            'Sign Up',
            style: GoogleFonts.poppins(
              color: const Color(0xFF667eea),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
