import 'dart:math';
import 'package:flutter/material.dart';
import 'package:makkah_app/Screens/QRShow.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:makkah_app/models/DB.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';

class TicketsScreen extends StatelessWidget {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Widget generateQRCode(String data) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: 100.0,
    );
  }

  void navigateToQRShow(BuildContext context, String qrData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRShow(qrData: qrData),
      ),
    );
  }

  Widget buildTicketCard(BuildContext context, Map<String, dynamic> ticket) {
    final uniqueQRData = "${ticket['id']}_${ticket['destination']}_${ticket['time']}";
    return GestureDetector(
      onTap: () => navigateToQRShow(context, uniqueQRData),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(ticket['destination']),
              subtitle: Text("Time: ${ticket['time']}"),
            ),
            generateQRCode(uniqueQRData),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchTickets() async {
    return await _dbHelper.getTickets();
  }

  @override
  Widget build(BuildContext context) {
    final BottomButton renderer = BasicButtonRenderer();
    final HomePageNavigation pageNavigation = HomePageNavigation(context, renderer);

    return Scaffold(
      appBar: AppBar(title: Text('Tickets')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ticket = snapshot.data![index];
                return buildTicketCard(context, ticket);
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            pageNavigation.HomeButton(),
            pageNavigation.TicketsButton(),
            pageNavigation.SettingsButton(),
          ],
        ),
      ),
    );
  }
}