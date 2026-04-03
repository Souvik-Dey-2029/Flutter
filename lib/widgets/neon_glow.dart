import 'package:flutter/material.dart';
import '../core/theme.dart';

class NeonGlow extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blurRadius;
  final double spreadRadius;
  final double borderRadius;
  final bool isActive;

  const NeonGlow({
    super.key,
    required this.child,
    this.color = AuraColors.neonCyan,
    this.blurRadius = 20,
    this.spreadRadius = 0,
    this.borderRadius = 20,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: blurRadius * 2,
                  spreadRadius: spreadRadius + 2,
                ),
              ]
            : [],
      ),
      child: child,
    );
  }
}

/// A pulsing neon dot indicator
class NeonDot extends StatefulWidget {
  final Color color;
  final double size;
  final bool pulse;

  const NeonDot({
    super.key,
    required this.color,
    this.size = 10,
    this.pulse = false,
  });

  @override
  State<NeonDot> createState() => _NeonDotState();
}

class _NeonDotState extends State<NeonDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.pulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(
                  alpha: widget.pulse ? _animation.value : 0.5,
                ),
                blurRadius: widget.size * 1.5,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
