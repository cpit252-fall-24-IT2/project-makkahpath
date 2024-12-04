import 'package:flutter/material.dart';
import 'package:makkah_app/models/DB.dart';

class TicketCounterProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Map<String, int> ticketCounters = {};

  Future<void> incrementCounter(String stopName, String time, String destination) async {
    final uniqueKey = "${stopName.replaceAll(' ', '_')}_${time.replaceAll(' ', '_')}";
    int currentCounter = await _dbHelper.getTicketCounter(stopName, time);

    if (currentCounter <= 30) {
      currentCounter++;
      await _dbHelper.insertOrUpdateTicketCounter(stopName, time, currentCounter);
      ticketCounters[uniqueKey] = currentCounter;
      String qrCode = "STOP: $stopName | TIME: $time | DEST: $destination";
      await _dbHelper.insertTicket(stopName, time, destination, qrCode);
      notifyListeners();
    }
  }

  Future<int> getCounter(String stopName, String time) async {
    final uniqueKey = "${stopName.replaceAll(' ', '_')}_${time.replaceAll(' ', '_')}";
    if (ticketCounters.containsKey(uniqueKey)) {
      return ticketCounters[uniqueKey]!;
    } else {
      final counter = await _dbHelper.getTicketCounter(stopName, time);
      ticketCounters[uniqueKey] = counter;
      return counter;
    }
  }

  Future<void> decrementCounter(String stopName, String time) async {
    final uniqueKey = "${stopName.replaceAll(' ', '_')}_${time.replaceAll(' ', '_')}";
    int currentCounter = await _dbHelper.getTicketCounter(stopName, time);

    if (currentCounter > 0) {
      currentCounter--;
      await _dbHelper.insertOrUpdateTicketCounter(stopName, time, currentCounter - 1);
      ticketCounters[uniqueKey] = currentCounter - 1;
      notifyListeners();
    }
  }
}
