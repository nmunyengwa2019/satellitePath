import 'package:flutter/material.dart';
import 'package:sat_tracker/presentation/screens/satelliteScreen.dart';

import '../../data/dataproviders/loaddata.dart';
import '../../data/models/satellite.dart';

class SearchScreen extends StatefulWidget {
  List<Satellite> _satellites;

  SearchScreen({Key? key, List<Satellite>? satellites})
      : _satellites = satellites ?? [],
        super(key: key);

  List<Satellite> get satellites => _satellites;

  setSatellites(List<Satellite> satellites) {
    _satellites = satellites;
  }

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _searchQuery = '';
  final loadData = LoadData();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await loadData.loadSatellites();
    setState(() {
      widget.setSatellites(loadData.satellites);
    });
  }


  void _handleSatelliteTap(Satellite satellite) {
    final selectedSatelliteName = satellite.name;
    final selectedSatelliteTleLine1 = satellite.tleLine1;
    final selectedSatelliteTleLine2 = satellite.tleLine2;

    // Navigate to the satellite tracking screen and pass the selected satellite data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SatelliteScreen(
          selectedSatelliteName: selectedSatelliteName,
          selectedSatelliteTleLine1: selectedSatelliteTleLine1,
          selectedSatelliteTleLine2: selectedSatelliteTleLine2,
        ),
      ),
    );
  }

  void _search() {
    final filteredList = loadData.searchSatellites(_searchQuery.toLowerCase());
    if (_searchQuery.isEmpty) {
      // If search query is empty, reset the list to show all satellites
      setState(() {
        widget.setSatellites(filteredList);
      });
    }
    else {
      final visibleSatellites = widget.satellites;
      final filteredList = visibleSatellites.where((satellite) =>
          satellite.name.toLowerCase().contains(_searchQuery)).toList();
      setState(() {
        widget.setSatellites(filteredList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Satellites'),
        ),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search satellites...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _search();
                  })
            ]),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.satellites.length,
                    itemBuilder: (context, index) {
                      final satellite = widget.satellites[index];
                      final regex = RegExp('.*$_searchQuery.*');

                      if (_searchQuery.isEmpty ||
                          regex.hasMatch(satellite.name.toLowerCase())) {
                        return ListTile(
                            title: Text(satellite.name),
                            subtitle: Text(satellite.tleLine1),
                            onTap: () {
                              // Handle tap on a satellite item
                              _handleSatelliteTap(satellite);
                            });
                      } else {
                        return const SizedBox.shrink();
                      }
                    }))
          ],
        ));
  }
}
