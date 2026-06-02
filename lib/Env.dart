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

  @EnviedField(varName: 'LOGIN')
  static final String login = _Env.login;

  @EnviedField(varName: 'PASSWORD')
  static final String passwrod = _Env.passwrod;

  @EnviedField(varName: 'REFRESH_TOKEN')
  static final String refresh_token = _Env.refresh_token;

  @EnviedField(varName: 'LOGOUT')
  static final String logout = _Env.logout;

  @EnviedField(varName: 'PROFILE')
  static final String profile = _Env.profile;


}
