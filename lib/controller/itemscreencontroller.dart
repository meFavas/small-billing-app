import 'package:intl/intl.dart';

class Itemscreencontroller {
   String generateInvoiceNumber() {
    DateTime now = DateTime.now();
    String year =
        now.year.toString().substring(2); // Last two digits of the year
    String month =
        now.month.toString().padLeft(2, '0'); // Month with leading zero
    String invoiceId =
        "01"; // This could be dynamically generated, e.g., based on an order count.
    return "$year-$month-$invoiceId"; // Format: yy-MM-01
  }

   String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now); // Format as dd/MM/yyyy
  }
    double calculateTotal(double quantity, double rate, double tax) {
    return (quantity * rate) + ((quantity * rate) * tax / 100);
  }

 

 
    // Implement your method to generate invoice numbers
  
 
}
