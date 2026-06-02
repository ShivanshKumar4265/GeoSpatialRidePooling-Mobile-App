import 'package:geo_spatial_ride_pooling_system_2/core/services/base_api_response.dart';

import '../../../Env.dart';
import '../../../core/constant/shared_pref_constant.dart';
import '../../../core/services/ApiService.dart';
import '../../../core/utils/shared_pref_util.dart';
import '../modal/auth_response.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<BaseApiResponse<AuthData>> createPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _apiService.request(
      'POST',
      Env.passwrod,
      body: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    final model = BaseApiResponse<AuthData>.fromJson(
      response,
      (data) => AuthData.fromJson(data),
    );

    if (!model.status) {
      throw Exception(model.message);
    }

    if (model.data != null) {
      saveData(model.data!);
    }

    return model;
  }

  Future<BaseApiResponse<AuthData>> login({
    required String email,
    required String password,
  }) async {
    // this is login
    final response = await _apiService.request(
      'POST',
      Env.login,
      body: {'email': email, 'password': password},
    );

    final model = BaseApiResponse<AuthData>.fromJson(
      response,
      (data) => AuthData.fromJson(data),
    );

    if (model.status != true) {
      throw Exception(model.message);
    }

    if (model.data != null) {
      saveData(model.data!);
    }

    return model;
  }

  void saveData(AuthData model) {
    SharedPreferencesUtil.instance.setBoolData(
      SharedPrefConstant.isLoggedIn,
      true,
    );
    SharedPreferencesUtil.instance.setStringData(
      SharedPrefConstant.accessToken,
      model?.accessToken ?? '',
    );
    SharedPreferencesUtil.instance.setStringData(
      SharedPrefConstant.refreshToken,
      model?.refreshToken ?? '',
    );
  }
}
