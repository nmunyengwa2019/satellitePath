import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sat_tracker/presentation/screens/plottingScreen.dart';
import '../../data/dataproviders/loaddata.dart';
import '../../data/models/satellite.dart';
import '../../data/models/satellite_model.dart';

class SearchScreen extends StatefulWidget {
  List<String> satelliteNames;

  SearchScreen({Key? key, required this.satelliteNames, }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TrackSatellite trackSatellite = TrackSatellite();
  double _loadingProgress = 0.0;
  late String _searchQuery = '';
  List<SatelliteData> _satelliteList = [];

  @override
  void initState(){
    super.initState();
    processSatellites();
  }

  Future<void> processSatellites() async {
    LoadData loadData = LoadData();
    final results = await loadData.loadSatellites(
      onProgress: (progress) {
        setState(() {
          _loadingProgress = progress;
        });
      },
    );
    _satelliteList = results;
    final result = await loadData.loadSatelliteNames();
    setState(() {
      widget.satelliteNames = result;
      _loadingProgress = 1.0;
    });
  }

  Future<void> _selectSatellite(SatelliteData satellite) async {

    final result = await trackSatellite.calculatePositions( satellite.TLE_LINE0!, satellite.TLE_LINE1!, satellite.TLE_LINE2!,);

    List<LatLng> formattedPositions = result.map((position) {
      double formattedLatitude = position.latitude;
      double formattedLongitude = position.longitude;
      return LatLng(formattedLatitude, formattedLongitude);
    }).toList();

    if (formattedPositions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            title: 'Map Screen',
            positions: formattedPositions,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Positions'),
          content: const Text('No positions data available for this satellite.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProgress < 1.0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search Satellites'),
        ),
        body: Center(
          child: CircularProgressIndicator(value: _loadingProgress),
        ),
      );
    } else {
      List<String> filteredSatellites = widget.satelliteNames.where((satelliteName) =>
          satelliteName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
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
                    })
              ]),
              Expanded(
                  child: ListView.builder(
                    itemCount: filteredSatellites.length,
                    itemBuilder: (context, index) {
                      final satelliteName = filteredSatellites[index];
                      final satellite = _satelliteList.firstWhere((
                          satellite) => satellite.TLE_LINE0 == satelliteName);
                      return ListTile(
                        title: Text(satelliteName),
                        onTap: () {
                          _selectSatellite(satellite);
                        },
                      );
                    },
                  )
              )
            ],
          )
      );
    }
  }
}
