import 'package:entity/entity.dart';

abstract class UpdateTextUseCase {
  Future<TextEntity> call(String text);
}
