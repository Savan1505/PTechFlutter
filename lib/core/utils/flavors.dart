enum Environment { dev, qa, production }

class Flavors {
  Environment? environment;
  String? baseUrl;
  String? appName;
  String? keycloakUrl;
  String? redirectUrl;
  int? openIdPort;
  String? clientId;
  String? clientSecret;
  List<String>? scopes;
  String? guid;

  static final Flavors _instance = Flavors._internal();

  Flavors._internal();

  factory Flavors({
    required environment,
    required baseUrl,
    required appName,
    required keycloakUrl,
    required redirectUrl,
    required openIdPort,
    required clientId,
    required clientSecret,
    required scopes,
    required guid,
  }) {
    _instance.environment = environment;
    _instance.baseUrl = baseUrl;
    _instance.appName = appName;
    _instance.keycloakUrl = keycloakUrl;
    _instance.redirectUrl = redirectUrl;
    _instance.openIdPort = openIdPort;
    _instance.clientId = clientId;
    _instance.clientSecret = clientSecret;
    _instance.scopes = scopes;
    _instance.guid = guid;
    return _instance;
  }

  static bool isProduction() => _instance.environment == Environment.production;

  static bool isDevelopment() => _instance.environment == Environment.dev;

  static bool isQA() => _instance.environment == Environment.qa;

  static String? getBaseUrl() => _instance.baseUrl;

  static String? getKeyCloakUrl() => _instance.keycloakUrl;

  static String? getRedirectUrl() => _instance.redirectUrl;

  static int? getOpenIdPortPort() => _instance.openIdPort;

  static String? getClientId() => _instance.clientId;

  static String? getClientSecret() => _instance.clientSecret;

  static List<String>? getScopes() => _instance.scopes;

  static String? getGuid() => _instance.guid;
}
