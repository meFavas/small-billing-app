// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:billing/controller/billingscreencontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'itemscreen.dart';

class Billingscreen extends StatefulWidget {
  const Billingscreen({super.key});

  @override
  _BillingscreenState createState() => _BillingscreenState();
}

class _BillingscreenState extends State<Billingscreen> {
  final BillingscreenController billingcontroller = BillingscreenController();
  double totalAmount = 0.0;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _billingNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void _updateTotal(double newTotal) {
    setState(() {
      totalAmount = newTotal;
    });
  }

  void saveToFirebase() {
    billingcontroller
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Invoice No.",
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    Text(
                      billingcontroller.generateInvoiceNumber(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    Text(
                      billingcontroller.getCurrentDate(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Firm Name:",
                    style: TextStyle(fontSize: 17, color: Colors.grey[700]),
                  ),
                  Text(
                    "  xianinfotech LLP",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 5,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            height: 26,
                            width: 26,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blue[800]),
                          ),
                          Text(
                            " Add Items",
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "(Optional)",
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                          )
                        ],
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
                        totalAmount
                            .toStringAsFixed(2), // Display updated total amount
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
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
                  saveToFirebase();
                  Navigator.pop(context); // Call the function to save data
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
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
