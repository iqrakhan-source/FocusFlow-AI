import 'package:flutter/material.dart';
/// Primary filled button used throughout FocusFlow AI.
///
/// Supports:
/// - Loading state
/// - Disabled state
/// - Theme-based styling
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        )
            : Text(text,
        style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

}