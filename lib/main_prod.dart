import 'package:ptecpos_mobile/core/utils/flavors.dart';
import 'package:ptecpos_mobile/main.dart';

void main() {
  mainConfig(
    Flavors(
      appName: "PTECPOS",
      //Production url
      baseUrl: "",
      keycloakUrl: '',
      redirectUrl: '',
      openIdPort: 7001,
      clientId: "mobile_ptechpos_local",
      clientSecret: '',
      scopes: ['profile', 'micro_api'],
      environment: Environment.production,
      guid: '00000000-0000-0000-0000-000000000000',
    ),
  );
}
