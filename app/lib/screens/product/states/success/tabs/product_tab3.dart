import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductTab3 extends StatelessWidget {
  const ProductTab3({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    if (product.nutritionFacts == null) {
      return const SizedBox.shrink();
    }

    return DefaultTextStyle.merge(
      style: TextStyle(color: AppColors.blue),
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: AppColors.blue),
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: _body(context, product.nutritionFacts!),
      ),
    );
  }

  List<TableRow> _body(BuildContext context, NutritionFacts nutritionFacts) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final NumberFormat numberFormat = NumberFormat.decimalPatternDigits(
      locale: Localizations.localeOf(context).countryCode,
      decimalDigits: 1,
    );

    final List<TableRow?> rows = <TableRow?>[];

    rows.add(
      TableRow(
        children: <Widget>[
          TableCell(child: SizedBox.shrink()),
          _NutritionFactsValue(
            text: localizations.product_nutrition_facts_per_100g,
          ),
          _NutritionFactsValue(
            text: localizations.product_nutrition_facts_per_serving,
          ),
        ],
      ),
    );

    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_energy,
        nutritionFacts.energy,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_fat,
        nutritionFacts.fat,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_saturated_fats,
        nutritionFacts.saturatedFat,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_carbohydrates,
        nutritionFacts.carbohydrate,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_sugars,
        nutritionFacts.sugar,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_fiber,
        nutritionFacts.fiber,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_proteins,
        nutritionFacts.proteins,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_salt,
        nutritionFacts.salt,
      ),
    );
    rows.add(
      _generateCell(
        numberFormat,
        localizations.product_nutrition_facts_sodium,
        nutritionFacts.sodium,
      ),
    );

    return rows.nonNulls.toList(growable: false);
  }

  TableRow? _generateCell(
    NumberFormat numberFormat,
    String label,
    Nutriment? nutriment,
  ) {
    if (nutriment == null) {
      return null;
    }

    String formatField(dynamic field, String unit) {
      if (field == null) {
        return '-';
      } else if (field is num) {
        return '${numberFormat.format(field)} $unit';
      } else {
        return '$field $unit';
      }
    }

    return TableRow(
      children: <Widget>[
        _NutritionFactsTitle(text: label),
        _NutritionFactsValue(
          text: formatField(nutriment.per100g, nutriment.unit),
        ),
        _NutritionFactsValue(
          text: formatField(nutriment.perServing, nutriment.unit),
        ),
      ],
    );
  }
}

class _NutritionFactsValue extends StatelessWidget {
  const _NutritionFactsValue({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 4.0,
        vertical: 6.0,
      ),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}

class _NutritionFactsTitle extends StatelessWidget {
  const _NutritionFactsTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 4.0,
        vertical: 6.0,
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

extension ProductNutrimentsExtension on Product {}
