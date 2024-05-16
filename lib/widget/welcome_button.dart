import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton(
      {super.key, this.buttonText, this.onTap, this.color, this.textColor});
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (e) => onTap!,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            10.0, 0, 10.0, 10.0), // Adjust the padding as needed
        child: Container(
          width: double.infinity, // Width set to match parent
          height: 120.0, // Keep the height of the container
          padding: const EdgeInsets.all(0), // Set padding to 0
          decoration: BoxDecoration(
            color: color!,
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
                  buttonText!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: textColor!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
