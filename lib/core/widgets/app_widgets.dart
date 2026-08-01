import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo real de la app (assets/icon/app_icon.png — el que subiste).
/// Usar SIEMPRE este widget en vez de dibujar un ícono placeholder:
/// aparece en el splash, el AppBar de Home y cualquier lugar de marca.
class AppLogo extends StatelessWidget {
  final double size;
  final BorderRadius? borderRadius;

  const AppLogo({super.key, this.size = 40, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/icon/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// Logo + wordmark "MyBand", para el splash y pantallas de marca.
class AppLogoWithWordmark extends StatelessWidget {
  final double logoSize;

  const AppLogoWithWordmark({super.key, this.logoSize = 64});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: logoSize),
        const SizedBox(height: 12),
        Text(
          'MYBAND',
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.displayLarge!.fontFamily,
            fontSize: 24,
            letterSpacing: 4,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}

/// Input consistente con la maqueta: ícono a la izquierda, fondo tarjeta,
/// bordes redondeados. Usar en todas las pantallas de auth y formularios.
class AppTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.text, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 18, color: AppColors.muted),
        hintText: hint,
      ),
    );
  }
}

/// Titular grande en mayúscula, estilo "ORGANIZÁ TU BANDA" de la maqueta.
/// [highlight] permite pintar la última palabra/línea en color lima.
class ScreenHeadline extends StatelessWidget {
  final String text;
  final String? highlight;

  const ScreenHeadline(this.text, {super.key, this.highlight});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displayLarge!;
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: text.toUpperCase()),
          if (highlight != null)
            TextSpan(
              text: '\n${highlight!.toUpperCase()}',
              style: style.copyWith(color: AppColors.lime),
            ),
        ],
      ),
    );
  }
}

/// Chip seleccionable usado para instrumento/género (registro, crear banda).
class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.lime : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.lime : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? AppColors.onLime : AppColors.muted,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
