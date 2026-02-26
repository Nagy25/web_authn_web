class WebAuthnWebException implements Exception {
  WebAuthnWebException(this.operation, this.message, [this.cause]);

  final String operation;
  final String message;
  final Object? cause;

  @override
  String toString() {
    final buffer = StringBuffer('WebAuthnWebException($operation): $message');
    if (cause != null) {
      buffer.write(' Cause: $cause');
    }
    return buffer.toString();
  }
}
