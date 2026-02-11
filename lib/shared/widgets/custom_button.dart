import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonType type;
  final Color? color;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.type = ButtonType.elevated,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text);

    final EdgeInsets buttonPadding = padding ?? 
        const EdgeInsets.symmetric(vertical: 16, horizontal: 24);

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: buttonPadding,
          ),
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: color != null ? BorderSide(color: color!) : null,
            padding: buttonPadding,
          ),
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: color,
            padding: buttonPadding,
          ),
          child: child,
        );
    }
  }
}

enum ButtonType {
  elevated,
  outlined,
  text,
}