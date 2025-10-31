sealed class TextSideEffect {}

class ShowLoading extends TextSideEffect {}

class HideLoading extends TextSideEffect {}

class ShowError extends TextSideEffect {
  ShowError(this.message);

  final String message;
}
