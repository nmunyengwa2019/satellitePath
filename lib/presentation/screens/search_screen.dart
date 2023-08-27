import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sat_tracker/presentation/screens/plottingScreen.dart';
import '../../data/dataproviders/loaddata.dart';
import '../../data/models/satellite.dart';
import '../../data/models/satellite_model.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({Key? key, required List<String> satelliteNames, }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TrackSatellite trackSatellite = TrackSatellite();
  double _loadingProgress = 0.0;
  late String _searchQuery = '';
  List<String> _satelliteNames = [];
  List<SatelliteData> _satelliteList = [];

  @override
  void initState(){
    super.initState();
    processSatellites();
  }

  Future<List<SatelliteData>> processSatellites() async {
    LoadData loadData = LoadData();
    final results = await loadData.loadSatellites(
      onProgress: (progress) {
        setState(() {
          _loadingProgress = progress;
        });
      },
    );
    _satelliteList = results;
    final result = await trackSatellite.loadSatelliteNames();
    _satelliteNames = result;
    setState(() {
      _loadingProgress = 1.0;
    });

    return _satelliteList;
  }

  Future<void> _selectSatellite(SatelliteData satellite)  async {
    final result = await trackSatellite.calculatePositions(satellite.TLE_LINE0!,
        satellite.TLE_LINE1!, satellite.TLE_LINE2!);

    if (kDebugMode) {
      print (result);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          title: 'Map Screen',
          positions: result,// as List<LatLng>,
        ),
      ),
    );
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
      List<String> filteredSatellites = _satelliteNames.where((satelliteName) =>
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
                      //_search(); TODO Add code for search here
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
                          setState(() {
                            _selectSatellite(satellite);
                          });
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
