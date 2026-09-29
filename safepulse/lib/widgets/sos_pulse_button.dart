import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/sos_theme.dart';

/// Big red emergency button with two expanding pulse rings.
class SosPulseButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  const SosPulseButton({super.key, required this.onPressed, this.size = 280});

  @override
  State<SosPulseButton> createState() => _SosPulseButtonState();
}

class _SosPulseButtonState extends State<SosPulseButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _ring(double p) {
    final d = widget.size * (0.62 + 0.38 * p);
    return Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SosColors.red.withValues(alpha: (1 - p) * 0.55), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final core = widget.size * 0.62;
    final t = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: t.sosSemantic,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, _) => Stack(
            alignment: Alignment.center,
            children: [
              _ring(_c.value),
              _ring((_c.value + 0.5) % 1.0),
              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  widget.onPressed();
                },
                child: Container(
                  width: core,
                  height: core,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      colors: [Color(0xFFFF4A4A), SosColors.red, SosColors.redDeep],
                      stops: [0.0, 0.55, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(color: SosColors.red.withValues(alpha: 0.5), blurRadius: 44, spreadRadius: 2),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.tapFor, style: SosText.body(11, color: Colors.white70, weight: FontWeight.w600, spacing: 1.6)),
                      const SizedBox(height: 4),
                      Text(t.emergencyCaps, style: SosText.body(17, color: Colors.white, weight: FontWeight.w800, spacing: 0.4)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
