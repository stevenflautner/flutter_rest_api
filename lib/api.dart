library flutter_rest_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import 'error.dart';

typedef ApiError ErrorDeserializer(Map<String, dynamic> json);

class Api {

  final String ip;
  final String url;
  final Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final ErrorDeserializer errorDeserializer;
  final Duration timeout;
  final errorStream = StreamController<ApiError>();

  Api({
    @required this.ip,
    this.timeout = const Duration(milliseconds: 14000),
    this.errorDeserializer
  }) :
        url = 'http://$ip';

  Future post(String path, {@required Object data}) async {
    if (data is! String) data = jsonEncode(data);

    try {
      return _request(http.post(url + path, headers: headers, body: data));
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(String path) async {
    try {
      return _request(http.delete(url + path, headers: headers));
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> get(String path) async {
    try {
      return _request(http.get(url + path, headers: headers));
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _request(Future<Response> future) async {
    http.Response response;
    try {
      response = await future.timeout(timeout);
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
        ApiError error;
        if (errorDeserializer != null) {
          error = errorDeserializer(decode);
        } else {
          error = InternalApiError();
        }
        errorStream.add(error);
        throw error;
      }

    } else {
      if (response.statusCode != HttpStatus.ok) {
        print('ERROR STATUS CODE: ${response.statusCode}');
        throw InternalApiError();
      }
    }
  }

  void setAccessToken(String accessToken) {
    headers[HttpHeaders.authorizationHeader] = "Bearer $accessToken";
  }

  Stream<ApiError> get onError => errorStream.stream;

}