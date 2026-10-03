import 'package:equatable/equatable.dart';

import '../../../../authentication/domain/entities/user_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

final class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProfileUpdating extends ProfileState {
  final UserEntity user;

  const ProfileUpdating(this.user);

  @override
  List<Object?> get props => [user];
}

final class ProfileUpdateSuccess extends ProfileState {
  final UserEntity user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class ProfileUpdateFailure extends ProfileState {
  final UserEntity user;
  final String message;

  const ProfileUpdateFailure({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}
