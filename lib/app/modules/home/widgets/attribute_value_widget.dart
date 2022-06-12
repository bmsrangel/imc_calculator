import 'package:flutter/material.dart';

class AttributeValueWidget extends StatelessWidget {
  const AttributeValueWidget({
    Key? key,
    required this.attribute,
    required this.value,
    this.resolution = 1,
  }) : super(key: key);

  final String attribute;
  final double value;
  final int resolution;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(resolution),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          attribute,
        ),
      ],
    );
  }
}
