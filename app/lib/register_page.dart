import 'package:flutter/material.dart';
import 'package:formation_flutter/custom_button.dart';
import 'package:formation_flutter/custom_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Contrôleurs pour récupérer le texte
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();

  void _registerUser() {
    // Cette fonction sera appelée pour s'inscrire.
    // Pour l'instant, on se contente d'afficher les données.
    final email = _registerEmailController.text;
    final password = _registerPasswordController.text;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Inscription pour : $email')));
    // Ici, vous ajouterez la logique de création de compte réelle.
  }

  @override
  void dispose() {
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inscription',
          style: TextStyle(color: Color(0xFF001F5B)),
        ),
        // Le bouton retour est géré automatiquement par Flutter ici
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Inscription',
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
                controller: _registerEmailController,
              ),
              const SizedBox(height: 15),
              CustomInputField(
                icon: Icons.lock,
                hintText: 'Mot de passe',
                isPassword: true,
                controller: _registerPasswordController,
              ),
              const SizedBox(height: 40),
              CustomButton(text: 'S\'inscrire', onPressed: _registerUser),
            ],
          ),
        ),
      ),
    );
  }
}
