
import 'src/models.dart';
export 'src/exceptions.dart';
export 'src/models.dart';

import 'web_authn_web_platform_interface.dart';

/// High-level WebAuthn API for Flutter Web.
class WebAuthnWeb {
  /// Creates a new credential via WebAuthn (registration).
  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) {
    return WebAuthnWebPlatform.instance.register(publicKey);
  }

  /// Requests an assertion via WebAuthn (authentication).
  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) {
    return WebAuthnWebPlatform.instance.sign(publicKey);
  }

  /// Signals that a credential should be deleted on the authenticator.
  Future<void> deleteAuth(String credentialId, String rpId) {
    return WebAuthnWebPlatform.instance.deleteAuth(credentialId, rpId);
  }
}
