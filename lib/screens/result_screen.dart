import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.answered,
    required this.total,
  });

  final int score;
  final int answered;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.timeUp,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.scoreLabel(score),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.answeredLabel(answered, total),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const HomeScreen(),
                    ),
                    (_) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(l10n.playAgain),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
