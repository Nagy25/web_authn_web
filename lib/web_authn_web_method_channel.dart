import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/models.dart';
import 'web_authn_web_platform_interface.dart';

/// An implementation of [WebAuthnWebPlatform] that uses method channels.
class MethodChannelWebAuthnWeb extends WebAuthnWebPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('web_authn_web');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) async {
    throw UnimplementedError('register() has not been implemented on this platform.');
  }

  @override
  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) async {
    throw UnimplementedError('sign() has not been implemented on this platform.');
  }

  @override
  Future<void> deleteAuth(String credentialId, String rpId) async {
    throw UnimplementedError('deleteAuth() has not been implemented on this platform.');
  }
}
