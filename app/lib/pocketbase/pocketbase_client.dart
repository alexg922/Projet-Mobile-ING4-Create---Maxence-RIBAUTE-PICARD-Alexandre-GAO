import 'package:pocketbase/pocketbase.dart';

/// Client PocketBase partagé dans toute l'application.

///    - Émulateur Android  → http://10.0.2.2:8090
///    - iPhone simulateur  → http://127.0.0.1:8090
///    - Appareil physique  → http://<IP_DU_PC>:8090
class PocketBaseClient {
  PocketBaseClient._();

  static const String _baseUrl = 'http://127.0.0.1:8090';

  static final PocketBase instance = PocketBase(_baseUrl);
}