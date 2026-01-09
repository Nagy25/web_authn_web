import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'src/models.dart';

import 'web_authn_web_method_channel.dart';

abstract class WebAuthnWebPlatform extends PlatformInterface {
  /// Constructs a WebAuthnWebPlatform.
  WebAuthnWebPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebAuthnWebPlatform _instance = MethodChannelWebAuthnWeb();

  /// The default instance of [WebAuthnWebPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebAuthnWeb].
  static WebAuthnWebPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebAuthnWebPlatform] when
  /// they register themselves.
  static set instance(WebAuthnWebPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) {
    throw UnimplementedError('sign() has not been implemented.');
  }

  Future<void> deleteAuth(String credentialId, String rpId) {
    throw UnimplementedError('deleteAuth() has not been implemented.');
  }
}
