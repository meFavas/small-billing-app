import 'package:billing/controller/itemscreencontroller.dart';
import 'package:flutter/material.dart';


class Itemscreen extends StatefulWidget {
  final Function(double) onUpdateTotal; // Callback to send total back to Billingscreen

  const Itemscreen({super.key, required this.onUpdateTotal});

  @override
  State<Itemscreen> createState() => _ItemscreenState();
}

class _ItemscreenState extends State<Itemscreen> {
  final Itemscreencontroller _controller = Itemscreencontroller();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();

  double total = 0.0;

  void _calculateTotal() {
    double quantity = double.tryParse(_quantityController.text) ?? 0;
    double rate = double.tryParse(_rateController.text) ?? 0;
    double tax = double.tryParse(_taxController.text) ?? 0;

    setState(() {
      total = _controller.calculateTotal(quantity, rate, tax); // Calculate total with tax
    });
  }

  void _saveItem() {
    _calculateTotal(); // Ensure the total is calculated before saving
    widget.onUpdateTotal(total); // Send total back to Billingscreen
    Navigator.pop(context); // Pop the screen and go back to Billingscreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Items to Sale"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                label: Text("Item Name"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Quantity"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => _calculateTotal(), // Recalculate on change
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _unitController,
                    decoration: InputDecoration(
                      label: Text("Unit"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Rate (Price/Unit)"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => _calculateTotal(), // Recalculate on change
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _taxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Tax (%)"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => _calculateTotal(), // Recalculate on change
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _saveItem, // Call save item when pressed
              child: Container(
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
