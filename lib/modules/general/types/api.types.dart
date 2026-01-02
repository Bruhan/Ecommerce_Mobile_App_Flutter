class WebResponse<T> {
  final T results;
  final int statusCode;
  final String message;

  WebResponse({required this.results, required this.statusCode, required this.message});

  factory WebResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return WebResponse<T>(
        results: fromJsonT(json['results']),
        statusCode: json['statusCode'],
        message: json['message'],
    );
  }

  // toJson method to convert WebResponse<T> to Map
  Map<String, dynamic> toJson(Object Function(T) toJsonT) {
    return {
      'results': toJsonT(results),
      'statusCode': statusCode,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'WebResponse{results: $results, statusCode: $statusCode, message: $message}';
  }
}