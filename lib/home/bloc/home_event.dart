part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomePhotoOpened extends HomeEvent {
  const HomePhotoOpened();
}

class HomePhotoSelected extends HomeEvent {
  const HomePhotoSelected({
    required this.photoList,
  });

  final List<AssetEntity> photoList;

  @override
  List<Object> get props => [];
}
