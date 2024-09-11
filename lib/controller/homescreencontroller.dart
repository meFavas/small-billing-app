// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class HomescreenController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBillsStream() {
    return _firestore.collection('bills').orderBy('date', descending: true).snapshots();
  }

  Future<void> deleteBill(String billId) async {
    try {
      await _firestore.collection('bills').doc(billId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
