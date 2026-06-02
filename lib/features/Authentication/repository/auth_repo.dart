import '../../../Env.dart';
import '../../../core/constant/shared_pref_constant.dart';
import '../../../core/services/ApiService.dart';
import '../../../core/utils/shared_pref_util.dart';
import '../modal/password_response.dart';

class AuthRepository {
  final ApiService _apiService;
  AuthRepository(this._apiService);

  Future<PasswrodResponse> createPassword({
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

    final model = PasswrodResponse.fromJson(response);

    if (model.status != true) {
      throw Exception(model.message ?? 'Password creation failed');
    }

    saveData(model);

    return model;
  }

  void saveData(PasswrodResponse model) {
    SharedPreferencesUtil.instance.setBoolData(
      SharedPrefConstant.isLoggedIn,
      true,
    );
    SharedPreferencesUtil.instance.setStringData(
      SharedPrefConstant.accessToken,
      model.data?.accessToken ?? '',
    );
    SharedPreferencesUtil.instance.setStringData(
      SharedPrefConstant.refreshToken,
      model.data?.refreshToken ?? '',
    );
  }
}
