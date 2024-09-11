// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:billing/controller/billingscreencontroller.dart';
import 'package:flutter/material.dart';

import 'itemscreen.dart';

class Billingscreen extends StatefulWidget {
  const Billingscreen({super.key});

  @override
  _BillingscreenState createState() => _BillingscreenState();
}

class _BillingscreenState extends State<Billingscreen> {
  final BillingscreenController _controller = BillingscreenController();
  double totalAmount = 0.0;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _billingNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _updateTotal(double newTotal) {
    setState(() {
      totalAmount = newTotal;
    });
  }

  void _saveToFirebase() {
    _controller
        .saveToFirebase(
      customerName: _customerNameController.text,
      billingName: _billingNameController.text,
      phoneNumber: _phoneController.text,
      totalAmount: totalAmount,
    )
        .then((_) {
      _customerNameController.clear();
      _billingNameController.clear();
      _phoneController.clear();
      _updateTotal(0.0);
      Navigator.pop(context);
    }).catchError((e) {
      print("Error saving document: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sale",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Invoice No.",
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                      Text(
                        _controller.generateInvoiceNumber(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                      Text(
                        _controller.getCurrentDate(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "xianinfotech LLP",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Divider(
                thickness: 10,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                          label: Text("Customer*"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _billingNameController,
                      decoration: InputDecoration(
                          label: Text("Billing Name (optional)"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          label: Text("Phone Number"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Itemscreen(
                              onUpdateTotal: _updateTotal, // Pass the callback
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blue.shade700,
                            )),
                        child: Center(
                          child: Text(
                            " + Add Items",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          totalAmount.toStringAsFixed(
                              2), // Display updated total amount
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        _saveToFirebase();
                        Navigator.pop(
                            context); // Call the function to save data
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue[400]),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
