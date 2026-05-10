import 'package:envied/envied.dart';

part 'Env.g.dart'; // <--- This is required!

@Envied(path: 'secrets.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY')
  static final String apiKey = _Env.apiKey; // Use obfuscate: true for extra security (optional)

  @EnviedField(varName: 'BASE_URL')
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'MEDIA_BASE_URL')
  static final String media_base_url = _Env.media_base_url;

  @EnviedField(varName: 'GET_CONNECTION')
  static final String get_Connection = _Env.get_Connection;

  @EnviedField(varName: 'REGISTER')
  static final String register = _Env.register;

}
