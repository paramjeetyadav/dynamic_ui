// ignore_for_file: constant_identifier_names

abstract class AppConfig {
  String get baseUrl;
  String get name;
}

class StagConfig implements AppConfig {
  @override
  String get baseUrl => 'https://chatbot-api.grampower.com/';

  @override
  String get name => Environment.STAGING;
}

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String STAGING = 'STAGING';

  late AppConfig config;

  initConfig({String? environment}) {
    String defaultConfig = const String.fromEnvironment('ENVIRONMENT', defaultValue: Environment.STAGING);

    config = _getConfig(environment ?? defaultConfig);
  }

  AppConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.STAGING:
        return StagConfig();
      default:
        return StagConfig();
    }
  }
}
