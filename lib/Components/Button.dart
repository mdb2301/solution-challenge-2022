import 'package:flutter/material.dart';
import 'package:donation_app/globals/colors.dart' as colors;

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const PrimaryButton({ 
    Key? key,
    required this.child,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
      child:child,
      style:ElevatedButton.styleFrom(
        primary:colors.primary,
        elevation:0,
        padding:const EdgeInsets.symmetric(vertical:17)
      )
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;
  const SecondaryButton({ 
    Key? key,
    required this.child,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed:onPressed,
      child:child,
      style:ElevatedButton.styleFrom(
        primary:Colors.white,
        elevation:0,
        padding:const EdgeInsets.symmetric(vertical:17),
      )
    );
  }
}