class ApiError implements Exception {

  final String id;

  ApiError(this.id);

}

class InternalServerError extends ApiError { InternalServerError() : super('internal-server-error'); }
class ConnectionError extends ApiError { ConnectionError() : super('no-connection'); }