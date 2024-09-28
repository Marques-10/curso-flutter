import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {

  final dynamic label;
  final void Function()? onPressed;

  AdaptativeButton({
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
    ? CupertinoButton(
      child: Text(label), 
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.symmetric(
          horizontal: 20
        )
    )
    : ElevatedButton(
      child: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 20
        )
      ),
    );
  }
}