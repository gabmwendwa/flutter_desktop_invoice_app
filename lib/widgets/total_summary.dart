import 'package:flutter/material.dart';

class TotalSummary extends StatelessWidget {
  final double subTotal;
  final double totalVat;
  final double total;
  final String currency;

  const TotalSummary({
    super.key,
    required this.subTotal,
    required this.totalVat,
    required this.total,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("SUBTOTAL: $currency${subTotal.toStringAsFixed(2)}"),
          Text("VAT: $currency${totalVat.toStringAsFixed(2)}"),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.blue,
            child: Text(
              "TOTAL: $currency${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
