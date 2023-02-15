import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_tracker/blocs/app_blocs.dart';

import '../blocs/app_states.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({Key? key}) : super(key: key);

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  late UserBloc userBloc;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
            bloc: userBloc,
            builder: (context, state) {
              if (state is IsLoading) {
                return Container();
              } else if (state is Loaded) {
                return Container();
              }
              return Container();
            }));
  }
}
