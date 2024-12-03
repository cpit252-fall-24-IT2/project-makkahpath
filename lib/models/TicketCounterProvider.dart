import 'package:flutter/material.dart';
import 'package:makkah_app/models/DB.dart'; 

class TicketCounterProvider extends ChangeNotifier {
  // Create an instance of DatabaseHelper
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Map to track counters for each ticket based on unique key (stop_name + time)
  Map<String, int> ticketCounters = {};

  // Method to increment a counter for a specific ticket
  Future<void> incrementCounter(String stopName, String time) async {
    final uniqueKey = "${stopName.replaceAll(' ', '_')}_${time.replaceAll(' ', '_')}";
    
    // Get the current counter from the database
    int currentCounter = await _dbHelper.getTicketCounter(stopName, time);

    // Increment the counter if it's less than max
    if (currentCounter <= 30) {
      currentCounter++;

      // Save the updated counter to the database
      await _dbHelper.insertOrUpdateTicketCounter(stopName, time, currentCounter);

      // Update the in-memory map
      ticketCounters[uniqueKey] = currentCounter;

      // Notify listeners about the change
      notifyListeners();
    }
  }

  // Method to get the current counter for a specific ticket
  Future<int> getCounter(String stopName, String time) async {
    final uniqueKey = "${stopName.replaceAll(' ', '_')}_${time.replaceAll(' ', '_')}";
    
    if (ticketCounters.containsKey(uniqueKey)) {
      return ticketCounters[uniqueKey]!; // Return in-memory counter if available
    } else {
      // Load the counter from the database if it's not in memory
      final counter = await _dbHelper.getTicketCounter(stopName, time);
      ticketCounters[uniqueKey] = counter; // Save the loaded counter in-memory
      return counter;
    }
  }
}
