
import 'package:flutter/material.dart';
import 'package:sat_tracker/data/dataproviders/loaddata.dart';
import 'package:sat_tracker/presentation/screens/downloadScreen.dart';
import 'package:sat_tracker/presentation/screens/plottingScreen.dart';
import 'package:sat_tracker/presentation/screens/search_screen.dart';

import '../data/models/satellite.dart';

class NavBar extends StatelessWidget {
  final List<LoadData> satellites;

  const NavBar({Key? key, required this.satellites}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text('Tracker'),
          accountEmail: Text('audreytahwa@usf.edu'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image(
                image: AssetImage('assets/profile.png'),
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
              image: AssetImage(
                'assets/background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        ListView.builder(
          itemCount: satellites.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: const Icon(Icons.satellite_alt_rounded),
              title: const Text('Map View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen(positions: [], title: '',)),
                );
              },
            );
          }
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.map_sharp),
          title: const Text('Map View'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category_rounded),
          title: const Text('Category View'),
          // ignore: avoid_returning_null_for_void
          onTap: () => null,
        ),
        ListTile(
          leading: const Icon(Icons.youtube_searched_for_rounded),
          title: const Text('Search View'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen(satelliteNames: [],),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.satellite_alt_rounded),
          title: const Text('Download Data'),
          // ignore: avoid_returning_null_for_void
          onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DownloadScreen()),
              );
            },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Exit'),
          // ignore: avoid_returning_null_for_void
          onTap: () => null,
        ),
      ],
    ));
  }
}
