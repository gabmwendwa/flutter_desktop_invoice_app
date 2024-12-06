import 'package:flutter/material.dart';

Widget buildHeaderTextFeild(String label, TextEditingController controller) {
  return SizedBox(
    width: 200,
    child: TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );
}

Widget buildConactTextFeild(String label, TextEditingController controller) {
  return SizedBox(
    child: TextField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );
}
