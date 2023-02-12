import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserState extends Equatable {}

class UserLoadingState extends  UserState
{
  @override
  // TODO: implement props
  List<Object?> get props => [];
  
}
