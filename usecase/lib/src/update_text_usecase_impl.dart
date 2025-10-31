import 'package:entity/entity.dart';
import 'package:usecase/src/update_text_usecase.dart';

class UpdateTextUseCaseImpl implements UpdateTextUseCase {
  @override
  Future<TextEntity> call(String text) async {
    // In a real app, you might do some validation or other business logic here.
    return TextEntity(text);
  }
}
