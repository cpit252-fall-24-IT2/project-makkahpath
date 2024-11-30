import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makkah_app/Screens/HomePageNavigation.dart';
import 'package:makkah_app/Widgets/BottomButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BottomButton renderer = BasicButtonRenderer();
  final List<Map<String, dynamic>> busStops = [];
  final Set<String> uniqueStopNames = {}; // To ensure unique bus stop names
  String selectedStop = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBusStops();
  }

  Future<void> loadBusStops() async {
    try {
      // Load JSON file
      final String jsonString =
          await rootBundle.loadString('assets/bus_route_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract bus stops from JSON data
      List<Map<String, dynamic>> stops = [];
      for (var route in jsonData['routes']) {
        for (var stop in route['bus_stops']) {
          // Only add unique stop names
          if (!uniqueStopNames.contains(stop['stop_name'])) {
            uniqueStopNames.add(stop['stop_name']);
          }
          // Add all stops for listing
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
    final HomePageNavigation pageNavigation =
        HomePageNavigation(context, renderer);

    // Filter bus stops based on the search or selected stop
    List<Map<String, dynamic>> filteredStops = selectedStop.isEmpty
        ? busStops
        : busStops
            .where((stop) =>
                stop["name"].toLowerCase().contains(selectedStop.toLowerCase()))
            .toList();

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
                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                title: Text(stop["name"]),
                                subtitle: Text(
                                    'Time: $time\nDestination: ${stop["destination"]}'),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Reservation logic here
                                  },
                                  child: const Text('Reserve'),
                                ),
                              ),
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
