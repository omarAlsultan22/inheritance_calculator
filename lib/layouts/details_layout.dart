import 'package:flutter/material.dart';


AppBar buildDetailsAppBar(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 0.0,
    title: const Text(
      'الشرح',
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
    backgroundColor: Colors.grey[900],
  );
}


Widget buildDetailsBody(Map<String, String> detailsItems) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: detailsItems.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        color: Colors.white,
        thickness: 0.1,
      ),
      itemBuilder: (context, index) {
        final key = detailsItems.keys.elementAt(index);
        final value = detailsItems[key]!;
        return _buildDetailRow(key, value);
      },
    ),
  );
}


Widget _buildDetailRow(String key, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}