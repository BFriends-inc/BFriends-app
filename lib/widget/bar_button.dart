import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    this.color,
    this.onColor,
    this.height,
    this.width,
    this.icon,
    this.text,
    this.tapDestination,
  });
  final Color? color, onColor;
  final double? height;
  final double? width;
  final IconData? icon;
  final String? text;
  final String? tapDestination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        debugPrint("Bar button pressed.");
        final nav = Provider.of<NavigationService>(context, listen: false);
        //nav.pushAuthOnPage(context: context, destination: tapDestination!);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        height: height ?? 20,
        width: width ??
            ((theme.textTheme.bodySmall!.fontSize! /
                    theme.textTheme.bodySmall!.height!) *
                text!.length),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: onColor,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text.toString(),
              style: TextStyle(
                  color: onColor,
                  fontStyle: theme.textTheme.bodySmall!.fontStyle,
                  fontSize: theme.textTheme.bodySmall!.fontSize),
            )
          ],
        ),
      ),
    );
  }
}
