import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makkah_app/models/TicketCounterProvider.dart';
import 'package:provider/provider.dart';
import 'TicketsScreen.dart';
import 'package:flutter/services.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';
import 'package:makkah_app/models/DB.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BottomButton renderer = BasicButtonRenderer();
  final List<Map<String, dynamic>> busStops = [];
  final Set<String> uniqueStopNames = {};
  String selectedStop = "";
  bool isLoading = true;
  final int maxReservations = 30;

  @override
  void initState() {
    super.initState();
    loadBusStops();
  }

  // Load bus stops and their ticket counters
  Future<void> loadBusStops() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/bus_route_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      List<Map<String, dynamic>> stops = [];
      for (var route in jsonData['routes']) {
        for (var stop in route['bus_stops']) {
          if (!uniqueStopNames.contains(stop['stop_name'])) {
            uniqueStopNames.add(stop['stop_name']);
          }

          // Initialize counters for each unique ticket (stop_name + time)
          for (var time in stop['times']) {
            // Fetch the counter from the database or initialize to 0
            int counter = await DatabaseHelper().getTicketCounter(stop['stop_name'], time);

            // Store it in the provider's in-memory state
            context.read<TicketCounterProvider>().ticketCounters["${stop['stop_name']}_$time"] = counter;
          }

          stops.add({
            "name": stop['stop_name'],
            "time": stop['times'],
            "destination": "Route ${route['route_number']}"
          });
        }
      }

      setState(() {
        busStops.addAll(stops);
        isLoading = false;
      });
    } catch (e) {
      print("Error loading bus stops: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomePageNavigation pageNavigation = HomePageNavigation(context, renderer);

    List<Map<String, dynamic>> filteredStops = selectedStop.isEmpty
        ? busStops
        : busStops.where((stop) => stop["name"].toLowerCase().contains(selectedStop.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by bus stop name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedStop = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  // Horizontal Scrollable Buttons for Unique Stops
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: uniqueStopNames.map((name) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedStop = name;
                              });
                            },
                            child: Text(name),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display Bus Stops
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredStops.length,
                      itemBuilder: (context, index) {
                        final stop = filteredStops[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: stop["time"].map<Widget>((time) {
                            String stopName = stop['name'];

                            return FutureBuilder<int>(
                              // Fetch the current count asynchronously
                              future: context.read<TicketCounterProvider>().getCounter(stopName, time),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Show a loading indicator while waiting
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // Handle error
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Successfully got the current count
                                  int currentCount = snapshot.data ?? 0;

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: ListTile(
                                      title: Text(stop["name"]),
                                      subtitle: Text('Time: $time\nDestination: ${stop["destination"]}'),
                                      trailing: SizedBox(
                                        width: 100, // Prevent overflow
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            // Counter Display
                                            Text(
                                              "$currentCount/$maxReservations",
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            // Reserve Button
                                            ElevatedButton(
                                              onPressed: currentCount < maxReservations
                                                  ? () async {
                                                      // Increment the counter
                                                      await context.read<TicketCounterProvider>().incrementCounter(stopName, time);

                                                      // Save the updated counter to the database
                                                      await DatabaseHelper().insertOrUpdateTicketCounter(stopName, time, currentCount + 1);

                                                      if (currentCount + 1 == maxReservations) {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          content: Text("The Bus is full, Find another one!!"),
                                                          duration: const Duration(seconds: 2),
                                                        ));
                                                      } else {
                                                        // Navigate to TicketsScreen if not full
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => TicketsScreen(),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              child: const Text('Reserve'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
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
