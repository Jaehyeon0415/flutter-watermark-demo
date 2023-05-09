import 'dart:io';

import 'package:equatable/equatable.dart';

class LocalPhoto  extends Equatable {
  const LocalPhoto({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.image,
  });

  final String id;

  final String name;

  final DateTime createdAt;

  final File image;

  @override
  List<Object> get props => [id, name, createdAt, image];
}