class InternalException implements Exception {
  late final String _message;

  InternalException(String message) {
    this._message = 'Internal exception: ' + message;
  }

  @override
  String toString() {
    return _message;
  }
}