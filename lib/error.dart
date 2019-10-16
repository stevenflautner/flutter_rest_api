import 'package:flutter/material.dart';

class ApiError implements Exception {

  final String id;

  ApiError(this.id);

  String msg(BuildContext context) {
    return id;
    //return AppLocalizations.of(context).translate(id) ?? id;
  }
}

class InternalServerError extends ApiError { InternalServerError() : super('internal-server-error'); }
class ConnectionError extends ApiError { ConnectionError() : super('no-connection'); }