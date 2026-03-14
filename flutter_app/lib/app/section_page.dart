import 'package:flutter/material.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> children;

  const SectionPage({
    super.key,
    required this.title,
    required this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCards extends StatelessWidget {
  final List<SummaryCardData> cards;

  const SummaryCards({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: cards
          .map(
            (card) => SizedBox(
              width: 240,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.label, style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      Text(card.value, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(card.caption),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class SummaryCardData {
  final String label;
  final String value;
  final String caption;

  const SummaryCardData({
    required this.label,
    required this.value,
    required this.caption,
  });
}

class ContentSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const ContentSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
