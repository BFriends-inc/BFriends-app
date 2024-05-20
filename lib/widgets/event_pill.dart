import 'package:flutter/material.dart';

class EventPill extends StatelessWidget {
  const EventPill({
    super.key,
    required this.title,
    required this.date,
    required this.imageURL,
    required this.maxPpl,
    required this.ppl,
  });
  final String title, imageURL;
  final DateTime date;
  final int ppl, maxPpl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedPositioned(
      bottom: -100,
      duration: Durations.short4,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.circular(50),
            boxShadow: <BoxShadow>[
              BoxShadow(
                blurRadius: 20,
                offset: Offset.zero,
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
          child: const Row(
              //image
              //column
              //info
              ),
        ),
      ),
    );
  }
}
