import 'package:equatable/equatable.dart';
import 'package:entity/entity.dart';

class TextState extends Equatable {
  final TextEntity? textEntity;

  const TextState({this.textEntity});

  TextState copyWith({TextEntity? textEntity}) {
    return TextState(
      textEntity: textEntity ?? this.textEntity,
    );
  }

  @override
  List<Object?> get props => [textEntity];
}
