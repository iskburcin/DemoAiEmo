import 'package:flutter/material.dart';

class MyBotton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyBotton({
    super.key,
    required this.text,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 70,
        padding: const EdgeInsets.all(25),
        child: Center(
          child: Text(text, style: const TextStyle(
            fontWeight: FontWeight.bold 
            ),
          ),
        ),
      ),
    );
  }
}