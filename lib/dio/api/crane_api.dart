import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/dio/dio_repo.dart';
import 'package:samsung_sss_flutter/models/json/crane/crane_model.dart';
import 'package:samsung_sss_flutter/models/json/crane/token_model.dart';

class CraneApi extends DioRepo {
  CraneApi(BuildContext context) {
    dioContext = context;
  }

  Future<Token> getOneTimeToken() async {
    try {
      Response response = await dio.get('v1/cms/crane/request-token');
      return Token.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Crane> getCraneDetail(String id) async {
    try {
      Response response = await dio.get('v1/cms/crane/$id');
      return Crane.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
