import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? assetPath;
  final VoidCallback? onAction;
  final String actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.assetPath,
    this.onAction,
    this.actionText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              Image.asset(
                assetPath!,
                width: 150,
                height: 150,
              )
            else
              Icon(
                Icons.inbox,
                size: 80,
                color: Colors.grey[400],
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (onAction != null)
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText),
              ),
          ],
        ),
      ),
    );
  }
}