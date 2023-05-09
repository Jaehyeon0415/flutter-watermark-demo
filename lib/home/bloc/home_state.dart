part of 'home_bloc.dart';

enum HomeStatus {initial, success, failure}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
  });

  final HomeStatus status;

  @override
  List<Object?> get props => [status];
}