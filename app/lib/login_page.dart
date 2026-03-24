import 'package:flutter/material.dart';
import 'package:formation_flutter/custom_button.dart';
import 'package:formation_flutter/custom_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour récupérer le texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() {
    // Cette fonction sera appelée pour se connecter.
    // Pour l'instant, on se contente d'afficher les données.
    final email = _emailController.text;
    final password = _passwordController.text;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Connexion pour : $email')));
    // Ici, vous ajouterez la logique d'authentification réelle.
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
      appBar: AppBar(
        title: const Text(
          'Connexion',
          style: TextStyle(color: Color(0xFF001F5B)),
        ),
        automaticallyImplyLeading:
            false, // Pas de bouton retour sur l'écran d'accueil
      ),
      body: Center(
        child: SingleChildScrollView(
          // Pour éviter les problèmes d'espace sur petit écran
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F5B),
                ),
              ),
              const SizedBox(height: 50),
              CustomInputField(
                icon: Icons.email,
                hintText: 'Adresse email',
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CustomInputField(
                icon: Icons.lock,
                hintText: 'Mot de passe',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Créer un compte',
                onPressed: () {
                  // Navigation vers la page d'inscription
                  Navigator.pushNamed(context, '/register');
                },
              ),
              const SizedBox(height: 15),
              CustomButton(text: 'Se connecter', onPressed: _loginUser),
            ],
          ),
        ),
      ),
    );
  }
}
