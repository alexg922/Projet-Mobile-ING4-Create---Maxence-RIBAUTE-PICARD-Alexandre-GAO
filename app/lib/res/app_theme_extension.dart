import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';

class OffThemeExtension extends ThemeExtension<OffThemeExtension> {
  OffThemeExtension({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.altText,
  });

  OffThemeExtension.defaultValues()
    : title1 = TextStyle(
        color: AppColors.blueDark,
        fontFamily: 'Avenir',
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      title2 = TextStyle(
        color: AppColors.grey2,
        fontFamily: 'Avenir',
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      title3 = TextStyle(
        color: AppColors.blueDark,
        fontFamily: 'Avenir',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      altText = TextStyle(
        color: AppColors.grey2,
        fontFamily: 'Avenir',
        fontSize: 15.0,
        fontWeight: FontWeight.normal,
      );

  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle altText;

  @override
  ThemeExtension<OffThemeExtension> copyWith({
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? altText,
  }) {
    return OffThemeExtension(
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      title3: title3 ?? this.title3,
      altText: altText ?? this.altText,
    );
  }

  @override
  ThemeExtension<OffThemeExtension> lerp(
    covariant ThemeExtension<OffThemeExtension>? other,
    double t,
  ) {
    if (other is! OffThemeExtension) {
      return this;
    }

    return OffThemeExtension(
      title1: TextStyle.lerp(title1, other.title1, t)!,
      title2: TextStyle.lerp(title2, other.title2, t)!,
      title3: TextStyle.lerp(title3, other.title3, t)!,
      altText: TextStyle.lerp(altText, other.altText, t)!,
    );
  }
}

extension OffThemeDartExtension on BuildContext {
  OffThemeExtension get theme => extension<OffThemeExtension>();

  T extension<T>() {
    return Theme.of(this).extension<T>()!;
  }
}
