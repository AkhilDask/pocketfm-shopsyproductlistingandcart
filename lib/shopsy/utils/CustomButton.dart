import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String title;
  final VoidCallback onPressed;
  const CustomButton({super.key,required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: onPressed,
      child: const Text('View',style: TextStyle(color: Colors.white),),
    );
  }


}