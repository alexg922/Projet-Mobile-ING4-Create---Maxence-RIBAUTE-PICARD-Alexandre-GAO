import 'package:flutter/material.dart';

class ProductPageError extends StatelessWidget {
  const ProductPageError({super.key, this.error});

  final dynamic error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error.toString()));
  }
}
