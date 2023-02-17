import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_tracker/widgets/form_results_widgets.dart';
import 'package:sgp4_sdp4/sgp4_sdp4.dart';

import '../blocs/app_blocs.dart';
import '../blocs/app_states.dart';
import '../main.dart';

class FormResultsScreen extends StatefulWidget {
  // final TextEditingController name;
  // final TextEditingController lineOne;
  // final TextEditingController lineTwo;

  const FormResultsScreen(
      {Key? key})
      : super(key: key);

  // const FormResultsScreen(
  //     {Key? key,
  //     required this.name,
  //     required this.lineOne,
  //     required this.lineTwo})
  //     : super(key: key);

  @override
  State<FormResultsScreen> createState() => _FormResultsScreenState();
}

class _FormResultsScreenState extends State<FormResultsScreen> {

  late UserBloc userBloc;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      title: 'Tracker',
                    )),
              );
            },
          ),
          centerTitle: true,
          title: const Text('Results', style: TextStyle(color: Colors.white)),
        ),
        body: BlocBuilder<UserBloc, UserState>(
            bloc: userBloc,
            builder: (context, state) {
              if (state is IsLoading) {
                return const Center(child: Text('Loading ...'));
              } else if (state is Loaded) {

                final TLE tleSGP4 = TLE(state.data.first.tLELINE0!, state.data.first.tLELINE1!, state.data.first.tLELINE1!);
                final Orbit orbit = Orbit(tleSGP4);
                bool status = orbit.period() < 255 * 60;

                final dateTime = DateTime.now();
                final double utcTime = Julian.fromFullDate(dateTime.year, dateTime.month,
                    dateTime.day, dateTime.hour, dateTime.minute).getDate() + 4 / 24.0;
                final Eci eciPos = orbit.getPosition((utcTime - orbit.epoch().getDate()) * MIN_PER_DAY);

                final CoordGeo coord = eciPos.toGeo();
                if (coord.lon > PI) coord.lon -= TWOPI;

                // todo : change hardcoded value
                final Site myLocation = Site.fromLatLngAlt(23.1359405517578, -82.3583297729492, 59 / 1000.0);

                CoordTopo topo = myLocation.getLookAngle(eciPos);


                return Container(
                    padding: const EdgeInsets.all(25),
                    child: ListView(children: [
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(title: 'Is SGP4', text: '$status')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Argument of Perigee',
                              text: '${rad2deg(orbit.argPerigee())}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Inclination',
                              text: '${rad2deg(orbit.inclination())}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Eccentricity', text: '${orbit.eccentricity()}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'RAAN', text: '${rad2deg(orbit.raan())}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Mean Motion', text: '${orbit.meanMotion()}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Mean Anonmoly',
                              text: '${rad2deg(orbit.meanAnomaly())}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Lat', text: '${rad2deg(coord.lat)}}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Lng', text: '${rad2deg(coord.lon)}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Azimut', text: '${rad2deg(topo.az)}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Elevation', text: '${rad2deg(topo.el)}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(title: 'Height', text: '${coord.alt}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(title: 'Range', text: '${topo.range}')),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: ResultWidget(
                              title: 'Period',
                              text: '${(orbit.period() / 60.0).round()} min')),
                    ]));
              }
              return const Center(child: Text('Error ...'));
            })
    );
  }
}
