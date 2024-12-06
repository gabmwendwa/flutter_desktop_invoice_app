import 'dart:io';

import 'package:flutter/material.dart';
import 'package:invoice/models/invoice_item_model.dart';
import 'package:invoice/widgets/invoice_contact_details.dart';
import 'package:invoice/widgets/invoice_header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invoice/widgets/item_table.dart';
import 'package:invoice/widgets/total_summary.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String currency = '\$';
  File? logoFile;

  final TextEditingController invoiceNumberController =
      TextEditingController(text: '20240001');
  final TextEditingController invoiceDateController = TextEditingController();

  final TextEditingController fromNameController = TextEditingController();
  final TextEditingController fromEmailController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController fromCityController = TextEditingController();
  final TextEditingController fromCountryController = TextEditingController();

  final TextEditingController billToNameController = TextEditingController();
  final TextEditingController billToEmailController = TextEditingController();
  final TextEditingController billToAddressController = TextEditingController();
  final TextEditingController billToCityController = TextEditingController();
  final TextEditingController billToCountryController = TextEditingController();

  List<InvoiceItem> items = [
    InvoiceItem(
      description: "Brochure Design",
      quantity: 1,
      unit: "pcs",
      price: 100,
      vat: 10,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final subTotal = _calculateSubTotal();
    final totalVat = _calculateTotalVat();
    final total = subTotal + totalVat;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoice Generator',
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InvoiceHeader(
                  logoFile: logoFile,
                  onLogoTap: _selectLogoFile,
                  invoiceNumberController: invoiceNumberController,
                  invoiceDateController: invoiceDateController,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InvoiceContactDetailsSection(
                        title: 'FROM',
                        nameController: fromNameController,
                        emailController: fromEmailController,
                        addressController: fromAddressController,
                        cityController: fromCityController,
                        countryController: fromCountryController,
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      child: InvoiceContactDetailsSection(
                        title: 'BILL TO',
                        nameController: billToNameController,
                        emailController: billToEmailController,
                        addressController: billToAddressController,
                        cityController: billToCityController,
                        countryController: billToCountryController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                ItemTable(
                  items: items,
                  onAddItem: onAddItem,
                  onRemoveItem: onRemoveItem,
                  onUpdateItemDescription: onUpdateItemDescription,
                  onUpdateItemQuantity: onUpdateItemQuantity,
                  onUpdateItemUnit: onUpdateItemUnit,
                  onUpdateItemPrice: onUpdateItemPrice,
                  onUpdateItemVat: onUpdateItemVat,
                ),
                const SizedBox(
                  height: 32,
                ),
                TotalSummary(
                  subTotal: subTotal,
                  totalVat: totalVat,
                  total: total,
                  currency: currency,
                ),
                _generatePDFButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectLogoFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        logoFile = File(result.files.single.path!);
      });
    }
  }

  void onAddItem() {
    setState(() {
      items.add(
        InvoiceItem(
          description: '',
          quantity: 1,
          unit: '',
          price: 0.0,
          vat: 0.0,
        ),
      );
    });
  }

  onRemoveItem(int i) {
    //index
    setState(() {
      items.removeAt(i);
    });
  }

  onUpdateItemDescription(int i, String val) {
    //index and value
    setState(() {
      items[i].description = val;
    });
  }

  onUpdateItemQuantity(int i, String val) {
    //index and value
    setState(() {
      items[i].quantity = int.tryParse(val) ?? 0;
    });
  }

  onUpdateItemUnit(int i, String val) {
    //index and value
    setState(() {
      items[i].unit = val;
    });
  }

  onUpdateItemPrice(int i, String val) {
    //index and value
    setState(() {
      items[i].price = double.tryParse(val) ?? 0;
    });
  }

  onUpdateItemVat(int i, String val) {
    //index and value
    setState(() {
      items[i].vat = double.tryParse(val) ?? 0;
    });
  }

  double _calculateSubTotal() => items.fold(
        0.0,
        (sum, item) => sum + item.quantity * item.price,
      );

  double _calculateTotalVat() => items.fold(
        0.0,
        (sum, item) => sum + item.quantity * item.price * item.vat / 100,
      );

  Widget _generatePDFButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _generatePDFInvoice,
        child: const Text('Generate PDF'),
      ),
    );
  }

  Future<void> _generatePDFInvoice() async {
    final pdf = pw.Document();

    pw.ImageProvider? pdfLogo;

    if (logoFile != null) {
      pdfLogo = pw.MemoryImage(await logoFile!.readAsBytes());
    }

    final subTotal = _calculateSubTotal();
    final totalVat = _calculateTotalVat();
    final total = subTotal + totalVat;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (pdfLogo != null)
              pw.Image(
                pdfLogo,
                width: 100,
                height: 100,
              ),
            pw.Text(
              'Invoice',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(
              height: 16,
            ),
            pw.Text('Invoice Number: ${invoiceNumberController.text}'),
            pw.Text('Invoice Date: ${invoiceDateController.text}'),
            pw.SizedBox(
              height: 16,
            ),
            pw.Text('From:'),
            pw.Text('Name: ${fromNameController.text}'),
            pw.Text('Email: ${fromEmailController.text}'),
            pw.Text('Address: ${fromAddressController.text}'),
            pw.Text('City: ${fromCityController.text}'),
            pw.Text('Country: ${fromCountryController.text}'),
            pw.SizedBox(
              height: 16,
            ),
            pw.Text('Bill To:'),
            pw.Text('Name: ${billToNameController.text}'),
            pw.Text('Email: ${billToEmailController.text}'),
            pw.Text('Address: ${billToAddressController.text}'),
            pw.Text('City: ${billToCityController.text}'),
            pw.Text('Country: ${billToCountryController.text}'),
            pw.SizedBox(
              height: 16,
            ),
            pw.Table.fromTextArray(
              headers: [
                'Item Description',
                'Quantity',
                'Unit',
                'Price',
                'Tax',
                'Total',
              ],
              data: items.map((item) {
                final itemTotal =
                    item.quantity * item.price * (1 + item.vat / 100);
                return [
                  item.description,
                  item.quantity,
                  item.unit,
                  item.price.toStringAsFixed(2),
                  item.vat.toStringAsFixed(2),
                  itemTotal.toStringAsFixed(2),
                ];
              }).toList(),
            ),
            pw.SizedBox(
              height: 16,
            ),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('SUBTOTAL: $currency${subTotal.toStringAsFixed(2)}'),
                  pw.Text('TAX: $currency${totalVat.toStringAsFixed(2)}'),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    color: PdfColors.blue,
                    child: pw.Text(
                      "TOTAL: $currency${total.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 18,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file =
        File('${output.path}/invoice-${invoiceNumberController.text}.pdf');

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
