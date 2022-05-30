class Failure implements Exception {
  final String message;
  Failure({required this.message});

  @override
  String toString() {
    return message;
  }
}
