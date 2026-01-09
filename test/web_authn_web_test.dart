import 'package:flutter_test/flutter_test.dart';
import 'package:web_authn_web/web_authn_web.dart';
import 'package:web_authn_web/web_authn_web_platform_interface.dart';
import 'package:web_authn_web/web_authn_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWebAuthnWebPlatform
    with MockPlatformInterfaceMixin
    implements WebAuthnWebPlatform {
  @override
  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) {
    return Future.value(<String, dynamic>{});
  }

  @override
  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) {
    return Future.value(<String, dynamic>{});
  }

  @override
  Future<void> deleteAuth(String credentialId, String rpId) {
    return Future.value();
  }
}

void main() {
  final WebAuthnWebPlatform initialPlatform = WebAuthnWebPlatform.instance;

  test('$MethodChannelWebAuthnWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebAuthnWeb>());
  });
}
