import 'package:flutter/material.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:formation_flutter/pocketbase/pocketbase_client.dart';

/// Cherche si un rappel produit existe pour un code-barres donné.
///
/// La table [rappels] stocke le code-barres dans le champ
/// [identification_lots] au format "BARCODE$…". On filtre donc
/// avec un opérateur LIKE.
class RappelFetcher extends ChangeNotifier {
  RappelFetcher({required String barcode}) : _barcode = barcode {
    _load();
  }

  final String _barcode;
  RappelFetcherState _state = const RappelFetcherLoading();

  RappelFetcherState get state => _state;

  Future<void> _load() async {
    _state = const RappelFetcherLoading();
    notifyListeners();

    try {
      // Le code-barres est le premier segment de identification_lots
      // Ex : "3383883752028$502926$..."
      final result = await PocketBaseClient.instance
          .collection('rappels')
          .getFirstListItem(
            "identification_lots ~ '${_barcode.replaceAll("'", "\\'")}%'",
          );

      _state = RappelFetcherFound(Rappel.fromRecord(result));
    } catch (_) {
      // Aucun rappel → état "aucun rappel"
      _state = const RappelFetcherNotFound();
    } finally {
      notifyListeners();
    }
  }

  void reload() => _load();
}

// États

sealed class RappelFetcherState {
  const RappelFetcherState();
}

class RappelFetcherLoading extends RappelFetcherState {
  const RappelFetcherLoading();
}

class RappelFetcherNotFound extends RappelFetcherState {
  const RappelFetcherNotFound();
}

class RappelFetcherFound extends RappelFetcherState {
  const RappelFetcherFound(this.rappel);

  final Rappel rappel;
}