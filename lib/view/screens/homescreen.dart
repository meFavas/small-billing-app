// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:billing/controller/homescreencontroller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'billingscreen.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final HomescreenController homecontroller = HomescreenController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("Homescreen"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      //floating actin button

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Billingscreen(),
            ),
          );
        },

        backgroundColor: Colors.red[500],
        label: Text(
          "₹  Add New Sale",
          style: TextStyle(color: Colors.white),
        ),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
        // child: Text(
        //   "₹",
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bills')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No bills available"));
            }

            final bills = snapshot.data!.docs;

            return Expanded(
              child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  final data = bill.data() as Map<String, dynamic>;
                  final billId = bill.id;

                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['customer_name'] ?? "Unknown",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data['invoice_number'] ?? "N/A",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    data['date'] ?? "N/A",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Sale text
                          Container(
                            child: Center(
                              child: Text(
                                "SALE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green[200],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 17),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    data['total_amount']?.toString() ?? "0.00",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Balance",
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 17),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    data['balance']?.toString() ?? "0.00",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.print_outlined),
                                    color: Colors.grey[700],
                                    onPressed: () {
                                      // Implement print functionality if needed
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send_outlined),
                                    onPressed: () {
                                      // Implement send functionality if needed
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_rounded),
                                    color: Colors.grey[700],
                                    onPressed: () {
                                      homecontroller.deleteBill(billId);
                                    },
                                  ),
                                  Icon(Icons.more_vert),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.signal_cellular_alt),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: "Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            label: "PREMIUM",
          ),
        ],
      ),
    );
  }
}
