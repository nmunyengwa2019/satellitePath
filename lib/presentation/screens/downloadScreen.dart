import 'package:flutter/material.dart';
import 'package:sat_tracker/presentation/screens/search_screen.dart';
import '../../data/dataproviders/download_data.dart';
import '../../data/dataproviders/loaddata.dart';


class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  LoadData loadData = LoadData();
  List<String>? satelliteNames;
  bool _downloading = false;
  double _progress = 0;
  String _status = '';

  @override
  void initState() {
    super.initState();
  }

  final ApiClient _apiClient = const ApiClient();

  Future<void> _showConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm download'),
          content: const Text('Do you want to download satellite data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _startDownload();
    }
  }

  Future<void> _startDownload() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _status = 'Downloading...';
    });

    try {
        await _apiClient.downloadSatellites((progress) {
          setState(() {
            _progress = progress;
          });
        });

        setState(() {
          _downloading = false;
          _progress = 1;
          _status = 'Download complete!';
        });

        satelliteNames = await loadData.loadSatelliteNames();

        if (satelliteNames != null && satelliteNames!.isNotEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>
                SearchScreen(satelliteNames: satelliteNames!)),
                (Route<dynamic> route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Satellite data downloaded successfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Satellite names found'),
            ),
          );
        }
      } on Exception catch (e) {
      setState(() {
        _downloading = false;
        _status = 'Download failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_downloading)
              LinearProgressIndicator(
                value: _progress,
              ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: const Text('Download'),
            ),
          ],
        ),
      ),
    );
  }
}