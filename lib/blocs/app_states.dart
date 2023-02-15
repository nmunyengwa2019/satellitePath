import 'package:equatable/equatable.dart';

import '../model/satellite_model.dart';


abstract class UserState {}

class IsLoading extends UserState {}

class Loaded extends UserState {
  final List<DataModel> data;
  Loaded({required this.data});
}

class Error extends UserState {}

