import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/dataproviders/download_data.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  bool _downloading = false;
  double _progress = 0;
  String _status = '';

  final ApiClient _apiClient = const ApiClient();

  Future<void> startDownload() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _status = 'Downloading...';
    });

    try {
      // Request permission to write to external storage
      var permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        throw Exception('Permission denied');
      }

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
      }
     on Exception catch (e)
     {
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startDownload,
        tooltip: 'Download',
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}