import 'package:flutter/material.dart';

class ProductPageEmpty extends StatelessWidget {
  const ProductPageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
