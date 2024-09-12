// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:billing/controller/itemscreencontroller.dart';
import 'package:flutter/material.dart';

class Itemscreen extends StatefulWidget {
  final Function(double)
      onUpdateTotal; // Callback to send total back to Billingscreen

  const Itemscreen({super.key, required this.onUpdateTotal});

  @override
  State<Itemscreen> createState() => _ItemscreenState();
}

class _ItemscreenState extends State<Itemscreen> {
  final Itemscreencontroller controller = Itemscreencontroller();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController itemController = TextEditingController();

  String _selectedUnit = 'kg'; // Default value for unit
  String selectedTax = '5'; // Default value for tax percentage
  double total = 0.0;

  // List of units and taxes for the dropdowns
  final List<String> _units = ['kg', 'lbs', 'pcs'];
  final List<String> _taxes = ['0', '5', '12', '18', '28'];

  void calculateTotal() {
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;
    double tax =
        double.tryParse(selectedTax) ?? 0; // Convert selected tax to double

    setState(() {
      total = controller.calculateTotal(
          quantity, rate, tax); // Calculate total with tax
    });
  }

  void saveItem() {
    calculateTotal(); // Ensure the total is calculated before saving
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
              controller: itemController,
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
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Quantity"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => calculateTotal(), // Recalculate on change
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    items: _units.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUnit = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Unit",
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
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text("Rate (Price/Unit)"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (_) => calculateTotal(), // Recalculate on change
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTax,
                    items: _taxes.map((String tax) {
                      return DropdownMenuItem<String>(
                        value: tax,
                        child: Text("$tax %"),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTax = newValue!;
                        calculateTotal(); // Recalculate on tax change
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Tax",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // GestureDetector(
            //   onTap: _saveItem, // Call save item when pressed
            //   child: Container(
            //     child: Center(
            //       child: Text(
            //         "Save",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            //       ),
            //     ),
            //     height: 60,
            //     width: 200,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: Colors.blue),
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Text(
                    "Save & New",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                height: 60,
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  saveItem();
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  height: 60,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
