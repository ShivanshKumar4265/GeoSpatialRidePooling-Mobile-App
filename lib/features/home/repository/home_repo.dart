import 'package:flutter/cupertino.dart';
import 'package:geo_spatial_ride_pooling_system_2/core/services/base_api_response.dart';
import '../../../Env.dart';
import '../../../core/constant/shared_pref_constant.dart';
import '../../../core/services/ApiService.dart';
import '../../../core/utils/shared_pref_util.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository(this._apiService);

  Future<BaseApiResponse<void>> logout() async {
    final token = await SharedPreferencesUtil.instance.getStringData(
      SharedPrefConstant.accessToken,
    );

    debugPrint('repo Logout token: $token'); // Debug print to check the token value

    final response = await _apiService.request(
      'POST',
      Env.logout,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final model = BaseApiResponse<void>.fromJson(
      response,
      (data) => null,
    );

    if (!model.status) {
      throw Exception(model.message);
    }

    if (model != null) {
      deleteData(model!);
    }
    return model;
  }


  void deleteData(dynamic model) {
    SharedPreferencesUtil.instance.clearAllExceptKeys([
      SharedPrefConstant.isFirstTime,
    ]);
  }
}
