enum ResponseStatus { success, failed, expired, error, waiting }

class ResponseModel<T> {
  final ResponseStatus responseStatus;
  final dynamic data;

  const ResponseModel({
    required this.responseStatus,
    required this.data,
  });
}
