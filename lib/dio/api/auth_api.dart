import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/constants.dart';
import 'package:samsung_sss_flutter/dio/dio_repo.dart';

import '../../models/json/auth/login_model.dart';

class AuthApi extends DioRepo {
  AuthApi(BuildContext context) {
    dioContext = context;
  }

  Future<AuthModel> login(
      BuildContext context, String username, String password) async {
    var params = {
      "username": username,
      "password": password,
      "clientType": Constants.CLIENT_TYPE
    };

    try {
      Response response = await dio.post('v1/auth/login', data: params);
      return AuthModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerCheck(
    String email,
    String password,
    String confirmPassword,
  ) async {
    var params = {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    };

    try {
      await dio.post('v1/auth/register/check', data: params);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
    String name,
    String dob,
    String phoneNo,
    String department,
    String designation,
    String company,
  ) async {
    var params = {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "name": name,
      "dob": dob,
      "mobileNo": phoneNo,
      "department": department,
      "designation": designation,
      "company": company,
    };

    try {
      await dio.post('v1/auth/register', data: params);
    } catch (e) {
      rethrow;
    }
  }
}
