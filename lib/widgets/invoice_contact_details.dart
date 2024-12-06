import 'package:flutter/material.dart';
import 'package:invoice/widgets/build_text_field.dart';

class InvoiceContactDetailsSection extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController countryController;

  const InvoiceContactDetailsSection({
    super.key,
    required this.title,
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.cityController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        buildConactTextFeild(
          "Name",
          nameController,
        ),
        const SizedBox(
          height: 8,
        ),
        buildConactTextFeild(
          "Email Address",
          emailController,
        ),
        const SizedBox(
          height: 8,
        ),
        buildConactTextFeild(
          "Billing Address",
          addressController,
        ),
        const SizedBox(
          height: 8,
        ),
        buildConactTextFeild(
          "City",
          cityController,
        ),
        const SizedBox(
          height: 8,
        ),
        buildConactTextFeild(
          "Country",
          countryController,
        ),
      ],
    );
  }
}
