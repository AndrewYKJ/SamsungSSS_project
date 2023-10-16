import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/dio/dio_repo.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_buidling_list_model.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_map_model.dart';
import 'package:samsung_sss_flutter/models/json/loto/loto_panel_model.dart';

import '../../models/json/loto/loto_panel_detail.dart';

class LOTOApi extends DioRepo {
  LOTOApi(BuildContext context) {
    dioContext = context;
  }

  Future<List<LotoBuildingDetails>> getAllBuilding() async {
    try {
      Response response = await dio.get('v1/cms/loto/building');
      final buildingList = (response.data as List).map((categoryData) {
        return LotoBuildingDetails.fromJson(categoryData);
      });
      return buildingList.toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<LotoMapModel> getBuildingMap(String id) async {
    try {
      Response response = await dio.get('v1/cms/loto/building/$id/map');
      return LotoMapModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<LotoPanelModel> getPanelList(
    int page,
    int size,
    String categoryId,
  ) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'buildingId': categoryId,
    };
    try {
      Response response = await dio.get(
        'v1/cms/loto/panel',
        queryParameters: params,
      );
      return LotoPanelModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<LotoPanelDetailModel> getPanelDetail(
    String categoryId,
  ) async {
    try {
      Response response = await dio.get(
        'v1/cms/loto/panel/$categoryId',
      );
      return LotoPanelDetailModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
