import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_tracker/data/dataproviders/download_data.dart';

import '../../business_logic/blocs/app_states.dart';
import 'app_events.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserBloc() : super(IsLoading()) {
    on<LoadUserEvent>((event, emit) async {
      final UserRepository _userRepository = UserRepository();
      final response = await _userRepository.getSatellites();
      emit(response);
    });
  }
}
