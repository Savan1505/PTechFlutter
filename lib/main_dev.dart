import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/main.dart';

void main() {
  mainConfig(
    Flavors(
      appName: "PTECPOS",
      //developer url
      baseUrl: "http://14.99.18.130:9000/",
      keycloakUrl: 'http://192.168.0.11:9005/',
      //keycloakUrl: 'http://14.99.18.130:9005/',
      redirectUrl: 'http://localhost:7001',
      openIdPort: 7001,
      clientId: "mobile_ptechpos_local",
      clientSecret: "57de30e2401387cee8f74bde6f66189b",
      scopes: ['profile', 'micro_api'],
      environment: Environment.dev,
      guid: '00000000-0000-0000-0000-000000000000',
    ),
  );
}
