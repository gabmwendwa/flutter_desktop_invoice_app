import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoice/widgets/build_text_field.dart';

class InvoiceHeader extends StatelessWidget {
  final File? logoFile;
  final VoidCallback onLogoTap;
  final TextEditingController invoiceNumberController;
  final TextEditingController invoiceDateController;

  const InvoiceHeader({
    super.key,
    required this.logoFile,
    required this.onLogoTap,
    required this.invoiceNumberController,
    required this.invoiceDateController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onLogoTap,
          child: Container(
            height: 100,
            width: 100,
            color: Colors.grey[300],
            child: logoFile == null
                ? Center(
                    child: Text(
                      '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : Image.file(
                    logoFile!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderTextFeild(
              "Invoice Number",
              invoiceNumberController,
            ),
            const SizedBox(
              height: 8,
            ),
            buildHeaderTextFeild(
              "Invoice Date",
              invoiceDateController,
            ),
          ],
        ),
      ],
    );
  }
}
