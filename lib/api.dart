library flutter_rest_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'error.dart';

class Api {

  final String ip;
  final String url;
  final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final errors = Map<String, ApiError>();
  final Duration timeout;

  Api({
    @required this.ip,
    this.timeout = const Duration(milliseconds: 14000),
    List<ApiError> errors,
  }) :
        url = 'http://$ip'
  {
    if (errors != null) {
      for (ApiError error in errors) {
        this.errors[error.id] = error;
      }
    }
  }

  Future post(String path, {@required Object data}) async {
    if (data is! String) data = jsonEncode(data);

    http.Response response;
    try {
      response = await http.post(url + path, headers: headers, body: data).timeout(timeout);
    } on SocketException catch (e) {
      throw ConnectionError();
    } on TimeoutException catch (e) {
      throw ConnectionError();
    }

    if (response.body.isNotEmpty) {
      final decode = jsonDecode(response.body);
      print(decode);

      if (response.statusCode == HttpStatus.ok) {
        return decode;
      } else {
        throw errors[decode];
      }

    } else {
      if (response.statusCode != HttpStatus.ok) {
        throw InternalServerError();
      }
    }
  }

  Future<void> delete(String path) async {
    http.Response response;
    try {
      response = await http.delete(url + path, headers: headers).timeout(timeout);
    } on SocketException catch (e) {
      throw ConnectionError();
    } on TimeoutException catch (e) {
      throw ConnectionError();
    }

    if (response.body.isNotEmpty) {
      final decode = jsonDecode(response.body);
      print(decode);

      if (response.statusCode == HttpStatus.ok) {
        return decode;
      } else {
        throw errors[decode];
      }

    } else {
      if (response.statusCode != HttpStatus.ok) {
        throw InternalServerError();
      }
    }
  }

  Future<dynamic> get(String path) async {
    http.Response response;
    try {
      response = await http.get(url + path, headers: headers).timeout(timeout);
    } on SocketException catch (e) {
      throw ConnectionError();
    } on TimeoutException catch (e) {
      throw ConnectionError();
    }

    if (response.body.isNotEmpty) {
      final decode = jsonDecode(response.body);
      print(decode);

      if (response.statusCode == HttpStatus.ok) {
        return decode;
      } else {
        throw errors[decode];
      }

    } else {
      if (response.statusCode != HttpStatus.ok) {
        throw InternalServerError();
      }
    }
  }

  void setAccessToken(String accessToken) {
    headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";
  }

}