import 'package:cloud_firestore/cloud_firestore.dart';
import 'itemscreencontroller.dart'; // Import to use the methods for date and invoice number

class BillingscreenController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Itemscreencontroller _itemscreenController = Itemscreencontroller();

  String getCurrentDate() {
    return _itemscreenController.getCurrentDate();
  }

  String generateInvoiceNumber() {
    return _itemscreenController.generateInvoiceNumber();
  }

  Future<void> saveToFirebase({
    required String customerName,
    required String billingName,
    required String phoneNumber,
    required double totalAmount,
  }) async {
    String currentDate = getCurrentDate();
    String invoiceNumber = generateInvoiceNumber();

    try {
      await _firestore.collection('bills').add({
        'customer_name': customerName,
        'billing_name': billingName,
        'phone_number': phoneNumber,
        'total_amount': totalAmount,
        'balance': totalAmount,
        'date': currentDate,
        'invoice_number': invoiceNumber,
      });
    } catch (e) {
      print("Error saving document: $e");
    }
  }
}
