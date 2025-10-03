import 'package:flutter/material.dart';

class ResultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;

  const ResultAppBar({Key? key, required this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: const Text(
        'النتيجة',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: onBackPressed,
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class DetailsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DetailsButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        height: 50,
        onPressed: onPressed,
        child: const Text(
          "التفاصيل",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.amber,
      ),
    );
  }
}