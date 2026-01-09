
import 'src/models.dart';
export 'src/models.dart';

import 'web_authn_web_platform_interface.dart';

class WebAuthnWeb {
  Future<String?> getPlatformVersion() {
    return WebAuthnWebPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) {
    return WebAuthnWebPlatform.instance.register(publicKey);
  }

  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) {
    return WebAuthnWebPlatform.instance.sign(publicKey);
  }

  Future<void> deleteAuth(String credentialId, String rpId) {
    return WebAuthnWebPlatform.instance.deleteAuth(credentialId, rpId);
  }
}
