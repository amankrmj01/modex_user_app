import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
              _showSnack(state.error, Colors.red.shade400);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) return const _LoadingOverlay();

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
                    child: _SignupForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      obscurePassword: _obscurePassword,
                      obscureConfirmPassword: _obscureConfirmPassword,
                      agreeToTerms: _agreeToTerms,
                      togglePassword: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      toggleConfirmPassword: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      onAgreeChanged: (val) =>
                          setState(() => _agreeToTerms = val ?? false),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnack(String msg, Color bg) {
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
              "Creating your account...",
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

class _SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreeToTerms;
  final VoidCallback togglePassword;
  final VoidCallback toggleConfirmPassword;
  final ValueChanged<bool?> onAgreeChanged;

  const _SignupForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.agreeToTerms,
    required this.togglePassword,
    required this.toggleConfirmPassword,
    required this.onAgreeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Logo(),
          const SizedBox(height: 24),
          _HeaderText(
            title: "Create Account",
            subtitle: "Join ModEx and start your culinary journey",
          ),
          const SizedBox(height: 32),
          _InputField(
            controller: nameController,
            label: 'Name',
            icon: Icons.person_outline,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          _InputField(
            controller: emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v!.isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _InputField(
            controller: phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 20),
          _PasswordField(
            controller: passwordController,
            label: 'Password',
            obscure: obscurePassword,
            toggle: togglePassword,
            validator: (v) {
              if (v!.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _PasswordField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            obscure: obscureConfirmPassword,
            toggle: toggleConfirmPassword,
            validator: (v) {
              if (v!.isEmpty) return 'Please confirm your password';
              if (v != passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 20),
          _TermsCheckbox(value: agreeToTerms, onChanged: onAgreeChanged),
          const SizedBox(height: 24),
          _SignUpButton(
            enabled: agreeToTerms,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignupRequested(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    password: passwordController.text,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          _DividerWidget(),
          const SizedBox(height: 24),
          _SocialButtons(),
          const SizedBox(height: 24),
          _SignInLink(),
        ],
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

class _HeaderText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return _InputWrapper(
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: _inputDecoration(label, icon),
        validator: validator,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback toggle;
  final String? Function(String?) validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.toggle,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return _InputWrapper(
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: _inputDecoration(label, Icons.lock_outline).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade600,
            ),
            onPressed: toggle,
          ),
        ),
        validator: validator,
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

InputDecoration _inputDecoration(String label, IconData icon) {
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

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF667eea),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF667eea),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF667eea),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _SignUpButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              )
            : null,
        color: enabled ? null : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: const Color(0xFF667eea).withAlpha((0.4 * 255).toInt()),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Create Account',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: enabled ? Colors.white : Colors.grey.shade600,
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
        onTap: () {}, // TODO: Implement
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

class _SignInLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.poppins(color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Sign In',
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
