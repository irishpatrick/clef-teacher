import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final Color? color;

  const Button({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        backgroundColor:
            color ?? Theme.of(context).colorScheme.secondaryContainer,
        elevation: 2,
        minimumSize: Size(150, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      ),
      child: child,
    );
  }
}
