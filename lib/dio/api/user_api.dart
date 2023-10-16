import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/dio/dio_repo.dart';
import 'package:samsung_sss_flutter/models/json/user/user_model.dart';

class UserApi extends DioRepo {
  UserApi(BuildContext context) {
    dioContext = context;
  }

  Future<UserModel> getUser() async {
    try {
      Response response = await dio.get('v1/user/me');
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateUser({required UserModel user}) async {
    try {
      Response response = await dio.put('v1/user/me', data: user.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await dio.post('v1/user/me/logout');
    } catch (e) {
      rethrow;
    }
  }
}
