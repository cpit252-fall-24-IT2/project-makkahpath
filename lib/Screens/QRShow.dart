import 'package:flutter/material.dart';
import 'package:makkah_app/models/DB.dart';
import 'package:makkah_app/models/TicketCounterProvider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRShow extends StatelessWidget {
  final String qrData;

  QRShow({required this.qrData});

  Future<void> cancelReservation(BuildContext context) async {
    // Parse the QR data to extract ticket details
    final ticketDetails = qrData.split('_'); // Assuming format: id_destination_time
    final ticketId = ticketDetails[0];
    final destination = ticketDetails[1];
    final time = ticketDetails[2];

    final DatabaseHelper dbHelper = DatabaseHelper();
    final ticketCounterProvider = Provider.of<TicketCounterProvider>(context, listen: false);

    // Delete the ticket from the database
    await dbHelper.deleteTicket(int.parse(ticketId));

    // Decrement the counter in the database and in the provider state
    int currentCounter = await dbHelper.getTicketCounter(destination, time);
    if (currentCounter > 0) {
      // Decrement the counter
      currentCounter--;
      await dbHelper.insertOrUpdateTicketCounter(destination, time, currentCounter);

      // Update the in-memory state as well
      ticketCounterProvider.ticketCounters["${destination}_$time"] = currentCounter;

      // Notify listeners to rebuild the UI
      ticketCounterProvider.notifyListeners();
    }

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reservation canceled successfully.')),
    );

    // Navigate back to the HomePage
    Navigator.pushReplacementNamed(context, '/home'); // Replace with HomePage route name
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
