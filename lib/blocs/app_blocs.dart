import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_tracker/api/download_data.dart';
import 'package:sat_tracker/blocs/app_events.dart';
import 'package:sat_tracker/blocs/app_states.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc() : super(IsLoading()) {
    on<LoadUserEvent>((event, emit) async {
      final UserRepository _userRepository = UserRepository();
      final response = await _userRepository.getSatellites();
      emit(response);
    });
  }
}
