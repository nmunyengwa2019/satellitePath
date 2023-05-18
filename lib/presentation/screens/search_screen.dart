import 'package:flutter/material.dart';
import '../../data/dataproviders/loaddata.dart';
import '../../data/models/satellite.dart';

class SearchScreen extends StatefulWidget {
  final List<Satellite> satellites;

  const SearchScreen({Key? key, required this.satellites}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _searchQuery;

  final loadData = LoadData();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await loadData.loadSatellites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Satellites'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search satellites...',
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.satellites.length,
              itemBuilder: (context, index) {
                final satellite = widget.satellites[index];
                if (_searchQuery.isEmpty ||
                    satellite.name.toLowerCase().contains(_searchQuery)) {
                  return ListTile(
                    title: Text(satellite.name),
                    subtitle: Text(satellite.tleLine1),
                    onTap: () {
                      // Handle tap on a satellite item
                      _handleSatelliteTap(satellite);
                    },
                  );
                } else {
                  return const SizedBox.shrink(); // Invisible widget for non-matching items
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleSatelliteTap(Satellite satellite) {
    // Handle tap on a satellite item
  }
}