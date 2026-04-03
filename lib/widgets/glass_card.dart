import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? glowColor;
  final bool hasGlow;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.glowColor,
    this.hasGlow = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AuraDecorations.cardRadius;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AuraDecorations.blurSigma,
          sigmaY: AuraDecorations.blurSigma,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AuraColors.cardGradient,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: hasGlow
                  ? (glowColor ?? AuraColors.neonCyan).withValues(alpha: 0.3)
                  : AuraColors.glassBorder,
              width: hasGlow ? 1.5 : 1,
            ),
            boxShadow: hasGlow
                ? AuraDecorations.neonShadow(
                    glowColor ?? AuraColors.neonCyan,
                    blur: 24,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null || onLongPress != null) {
      card = GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: card,
      );
    }

    return card;
  }
}
