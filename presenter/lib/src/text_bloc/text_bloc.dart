import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:presenter/src/text_bloc/text_event.dart';
import 'package:presenter/src/text_bloc/text_side_effect.dart';
import 'package:presenter/src/text_bloc/text_state.dart';
import 'package:usecase/usecase.dart';

class TextBloc extends Bloc<TextEvent, TextState> {
  final UpdateTextUseCase _updateTextUseCase;
  final _sideEffectController = StreamController<TextSideEffect>.broadcast();

  Stream<TextSideEffect> get sideEffectStream => _sideEffectController.stream;

  TextBloc({required UpdateTextUseCase updateTextUseCase})
    : _updateTextUseCase = updateTextUseCase,
      super(const TextState()) {
    on<SaveButtonPressed>(_onSaveButtonPressed);
  }

  Future<void> _onSaveButtonPressed(SaveButtonPressed event, Emitter<TextState> emit) async {
    _sideEffectController.add(ShowLoading());
    try {
      final textEntity = await _updateTextUseCase(event.text);
      emit(state.copyWith(textEntity: textEntity));
    } catch (e) {
      _sideEffectController.add(ShowError(e.toString()));
    } finally {
      _sideEffectController.add(HideLoading());
    }
  }

  @override
  Future<void> close() {
    _sideEffectController.close();
    return super.close();
  }
}
