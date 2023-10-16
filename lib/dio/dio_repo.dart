import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/app_font.dart';
import 'package:samsung_sss_flutter/routes/approutes.dart';

import '../controllers/landing/splash_screen.dart';
import 'interceptor/logging.dart';

class DioRepo {
  late Dio dio;
  int retryCount = 0;
  late BuildContext dioContext;

  static const host = "";

  Dio baseConfig() {
    Dio dio = Dio();
    dio.options.baseUrl = host;
    dio.options.connectTimeout = const Duration(milliseconds: 15000);
    dio.options.receiveTimeout = const Duration(milliseconds: 15000);
    dio.httpClientAdapter;

    return dio;
  }

  DioRepo() {
    dio = baseConfig();
    dio.interceptors.addAll([
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          //TODO: get token value

          AppCache.getStringValue(AppCache.ACCESS_TOKEN_PREF).then((value) {
            if (value.isNotEmpty) {
              options.headers[HttpHeaders.authorizationHeader] =
                  'Bearer ' + value;
            }
          });

          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            if (retryCount < 3) {
              return refreshTokenAndRetry(e.response!.requestOptions, handler);
            }
            showAlertDialog('System Error',
                'Opps, unexpected error has occured. Please try again later');
            return handler.next(e);
          }

          return handler.next(e);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
      ),
      LoggingInterceptors()
    ]);
  }

  Future<void> refreshTokenAndRetry(
      RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    bool isError = false;
    Dio tokenDio = baseConfig();
    var param = {
      "refreshToken": AppCache.getStringValue(AppCache.REFRESH_TOKEN_PREF)
    };

    tokenDio.options.headers['Accept'] = "application/json";
    tokenDio.options.headers['content-Type'] =
        'application/x-www-form-urlencoded';

    tokenDio.interceptors.add(LoggingInterceptors());
    try {
      tokenDio.post('v1/auth/access-token/refresh', data: param).then((res) {
        if (res.statusCode == 200) {
          AppCache.setAuthToken(
              res.data['accessToken'], res.data['refreshToken']);
        } else {
          isError = true;
          // EasyLoading.dismiss();

          AppCache.removeValues(dioContext);
          Navigator.pushAndRemoveUntil(
              dioContext,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (Route<dynamic> route) => false);
        }
      }).catchError((error) {
        isError = true;
        if (error is DioException) {
          if (error.response != null) {
            if (error.response!.data != null) {
              // EasyLoading.dismiss();
              showAlertDialog(error.response!.data['code'],
                  error.response!.data['message']);
            } else {
              // EasyLoading.dismiss();
              showAlertDialog('System Error',
                  'Opps, unexpected error has occured. Please try again later');
            }
          } else {
            AppCache.removeValues(dioContext);
            // EasyLoading.dismiss();
            Navigator.pushAndRemoveUntil(
                dioContext,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false);
          }
        } else {
          AppCache.removeValues(dioContext);
          // EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(dioContext,
              AppRoutes.splashScreenRoute, (Route<dynamic> route) => false);
        }
      }).whenComplete(() async {
        final originResult = await dio.fetch(requestOptions..path);

        if (originResult.statusCode != null &&
            originResult.statusCode! ~/ 100 == 2) {
          return handler.resolve(originResult);
        }
      }).then((e) {
        if (!isError) {
          retryCount++;
          dio.fetch(requestOptions).then(
            (r) => handler.resolve(r),
            onError: (e) {
              handler.reject(e);
            },
          );
        }
      });
      // ignore: unused_catch_clause
    } on DioException catch (e) {
      showAlertDialog("Error", "An error occurred");
    }
  }

  void showAlertDialog(String title, String message) {
    showDialog(
        context: dioContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: AppFont.helveticaNeueBold(16, color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Oops, an error has occured. Please check with administrator.',
                    style: AppFont.helveticaNeueBold(16, color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Done',
                  style: AppFont.helveticaNeueBold(16, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
