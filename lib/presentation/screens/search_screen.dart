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

  void _handleSatelliteTap(Satellite satellite) {
    // Handle tap on a satellite item
  }

  void _search() {
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
