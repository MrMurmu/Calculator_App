import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOperator;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.isOperator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:
              label == '='
                  ? Colors.blue.shade400
                  : (isOperator || label == '/'
                      ? Colors.blue.shade200
                      : Colors.black12),

          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1.1, color: Colors.white),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color:
                  label == '='
                      ? Colors.white
                      : (isOperator || label == '/' || label == 'Ac' || label == '⌫'
                          ? Colors.blue
                          : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
