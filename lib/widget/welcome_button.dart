import 'package:bfriends_app/services/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeButton extends StatefulWidget {
  const WelcomeButton({
    super.key,
    this.buttonText,
    this.tapDestination,
    this.color,
    this.hoverColor,
    this.textColor,
    this.textOpacity = 1.0, // Default opacity is fully opaque
    this.hoverOpacity = 1.0, // Default hover opacity
    this.pressedColor,
  });

  final String? buttonText;
  final String? tapDestination;
  final Color? color;
  final Color? hoverColor;
  final Color? textColor;
  final double textOpacity;
  final double hoverOpacity;
  final Color? pressedColor;

  @override
  _WelcomeButtonState createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<WelcomeButton> {
  Color? _currentColor;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        final nav = Provider.of<NavigationService>(context, listen: false);
        nav.pushAuthOnPage(
            context: context, destination: widget.tapDestination!);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _currentColor = widget.hoverColor?.withOpacity(widget.hoverOpacity);
          });
        },
        onExit: (event) {
          setState(() {
            _currentColor = widget.color;
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              10.0, 0, 10.0, 10.0), // Adjust the padding as needed
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity, // Width set to match parent
            height: 120.0, // Keep the height of the container
            padding: const EdgeInsets.all(0), // Set padding to 0
            decoration: BoxDecoration(
              color: _isPressed ? widget.pressedColor : _currentColor,
              borderRadius: BorderRadius.circular(
                  17.0), // Adjust the border radius as needed
            ),
            child: Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.buttonText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor?.withOpacity(widget.textOpacity),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
