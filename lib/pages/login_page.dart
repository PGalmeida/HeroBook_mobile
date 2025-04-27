import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:herobook/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herobook/pages/herobook.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HeroApp()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'user-not-found'
                ? 'Usuário não encontrado.'
                : e.code == 'wrong-password'
                    ? 'Senha incorreta.'
                    : 'Erro no login. Tente novamente.',
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // fundo escuro
      appBar: AppBar(
        title: Text(
          'HeroBook',
          style: GoogleFonts.limelight(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1F1F1F), // cor mais escura
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/hero.png',
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),
            Text(
              'Bem-vindo!',
              style: GoogleFonts.dmSerifText(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Faça login para continuar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                prefixIcon:
                    const Icon(Icons.email_outlined, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Senha',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF1F1F1F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade700,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Não tem uma conta? ',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const RegisterPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var fadeAnimation =
                              Tween(begin: 0.0, end: 1.0).animate(animation);
                          return FadeTransition(
                              opacity: fadeAnimation, child: child);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
