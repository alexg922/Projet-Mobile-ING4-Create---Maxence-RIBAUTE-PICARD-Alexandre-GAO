import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/pocketbase/pocketbase_client.dart';
import 'package:formation_flutter/login_page.dart';
import 'package:formation_flutter/register_page.dart';

void main() async {
  // INIT

  WidgetsFlutterBinding.ensureInitialized();

  // TESTS D'INTÉGRATION POCKETBASE
  final pb = PocketBaseClient.instance;

  print("TEST POCKETBASE ");

  try {
    // Tentative de récupération d'un seul enregistrement dans 'rappels'
    final result = await pb.collection('rappels').getList(page: 1, perPage: 1);

    if (result.items.isNotEmpty) {
      print("✅ SUCCÈS : Donnée trouvée dans la collection 'rappels' :");
      print(result.items.first.data);
    } else {
      print(
        "⚠️ OK : Connecté à PocketBase, mais la collection 'rappels' est vide.",
      );
    }
  } catch (e) {
    print("❌ ERREUR POCKETBASE : Impossible de contacter le serveur.");
    print("Détails de l'erreur : $e");
    print(
      "💡 Astuce : Vérifiez que l'URL dans pocketbase_client.dart est correcte pour votre appareil (ex: 10.0.2.2 pour Android).",
    );
  }
  // --- FIN DU TEST ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open Food Facts',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        extensions: [OffThemeExtension.defaultValues()],
        fontFamily: 'Avenir',
        dividerTheme: const DividerThemeData(
          color: AppColors.grey2,
          space: 1.0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.grey2,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppColors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Nous définissons une route initiale et un gestionnaire de routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
