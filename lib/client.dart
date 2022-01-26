import 'dart:math';
import 'package:flutter/material.dart' show Color;

final _random = Random();

class RestClient {
  Future<int> _fakeRequest() => Future.delayed(const Duration(seconds: 1))
      .then((_) => _random.nextBool() ? Future.value(200) : Future.error(500));

  Future<int> postCountry({required String country}) => _fakeRequest();

  Future<int> postColor({required Color color}) => _fakeRequest();
}

final client = RestClient();
