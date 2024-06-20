import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;
  final Color hoverColor;
  final Color textColor;
  final Color hoverTextColor;

  const HoverButton({
    required this.buttonText,
    required this.onPressed,
    required this.color,
    required this.hoverColor,
    required this.textColor,
    required this.hoverTextColor,
    Key? key,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: _isHovered ? widget.hoverColor : widget.color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: TextStyle(
                color: _isHovered ? widget.hoverTextColor : widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
