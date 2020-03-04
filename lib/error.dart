class ApiError implements Exception {

  final String id;

  ApiError(this.id);

}

class InternalApiError extends ApiError { InternalApiError() : super('internal-server-error'); }
class ConnectionError extends ApiError { ConnectionError() : super('no-connection'); }