import 'package:flutter/material.dart';
import 'package:makkah_app/models/DB.dart';
import 'package:makkah_app/models/TicketCounterProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRShow extends StatelessWidget {
  final String qrData;

  QRShow({required this.qrData});

  Future<void> cancelReservation(BuildContext context) async {
    try {
      final ticketDetails = parseQrData(qrData);
      final ticketId = int.parse(ticketDetails[0]);
      final destination = ticketDetails[1];
      final time = ticketDetails[2];

      await deleteTicket(ticketId);
      await updateTicketCounter(context, destination, time);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation canceled successfully.')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      handleError(context, e);
    }
  }

  List<String> parseQrData(String qrData) {
    return qrData.split('_');
  }

  Future<void> deleteTicket(int ticketId) async { // Change parameter type to int
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTicket(ticketId); // No parsing needed here
  }

  Future<void> updateTicketCounter(
      BuildContext context, String destination, String time) async {
    final dbHelper = DatabaseHelper();
    final ticketCounterProvider =
        Provider.of<TicketCounterProvider>(context, listen: false);

    int currentCounter = await dbHelper.getTicketCounter(destination, time);
    if (currentCounter > 0) {
      currentCounter--;
      await dbHelper.insertOrUpdateTicketCounter(
          destination, time, currentCounter);

      final uniqueKey = "${destination}_$time";
      ticketCounterProvider.ticketCounters[uniqueKey] = currentCounter;
      ticketCounterProvider.notifyListeners();
    }
  }

  void handleError(BuildContext context, Object error) {
    print('Error canceling reservation: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error canceling reservation. Please try again.')),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => cancelReservation(context),
            child: Text('Cancel Reservation'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
