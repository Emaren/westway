import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GradientSpinningCircle extends StatefulWidget {
  final double size;

  const GradientSpinningCircle({Key? key, required this.size})
      : super(key: key);

  @override
  _GradientSpinningCircleState createState() => _GradientSpinningCircleState();
}

class _GradientSpinningCircleState extends State<GradientSpinningCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color.fromARGB(255, 192, 1, 1),
            Color.fromARGB(255, 88, 0, 0),
          ],
        ),
      ),
      child: SpinKitSpinningCircle(
        controller: _animationController,
        color: Colors.transparent,
        size: widget.size,
      ),
    );
  }
}
