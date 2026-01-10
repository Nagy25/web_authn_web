// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'src/exceptions.dart';
import 'src/models.dart';
import 'web_authn_web_platform_interface.dart';

/// A web implementation of the WebAuthnWebPlatform of the WebAuthnWeb plugin.
class WebAuthnWebWeb extends WebAuthnWebPlatform {
  /// Constructs a WebAuthnWebWeb
  WebAuthnWebWeb() {
    _injectScript();
  }

  static void registerWith(Registrar registrar) {
    WebAuthnWebPlatform.instance = WebAuthnWebWeb(); //Register the instance
  }

  /// Injects the web_authen.js script into the head of the document
  void _injectScript() {
    final web.HTMLScriptElement script = web.HTMLScriptElement();
    // Using the asset path from the package
    script.src = 'assets/packages/web_authn_web/assets/web_authen.js';
    script.type = 'text/javascript';
    script.defer = true;
    web.document.head?.append(script);
  }
  
  // ignore: unused_element
  Future<void> _ensureScriptLoaded() async {
      // Basic polling to wait for script load if needed, though simple injection usually works for async user init
      // 'register', 'sign' are bound to window. 
      // In a real app, you might want to wait for 'load' event of script.
  }


  @override
  Future<Map<String, dynamic>> register(PublicKeyCredentialCreationOptions publicKey) async {
    try {
      final jsOptions = publicKey.toJson().jsify();
      final result = await _register(jsOptions).toDart;
      return (result.dartify() as Map<Object?, Object?>).cast<String, dynamic>();

    } catch (e) {
      throw WebAuthnWebException(
        'register',
        'Registration failed. Check HTTPS/localhost, rpId domain match, and browser WebAuthn support.',
        e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sign(PublicKeyCredentialRequestOptions publicKey) async {
    try {
      final jsOptions = publicKey.toJson().jsify();
      final result = await _sign(jsOptions).toDart;
      return (result.dartify() as Map<Object?, Object?>).cast<String, dynamic>();
    } catch (e) {
      throw WebAuthnWebException(
        'sign',
        'Authentication failed. Check HTTPS/localhost, rpId domain match, and user verification requirements.',
        e,
      );
    }
  }

  @override
  Future<void> deleteAuth(String credentialId, String rpId) async {
    try {
       final jsOptions = {'id': credentialId, 'rpId': rpId}.jsify();
       await _deleteAuth(jsOptions).toDart;
    } catch (e) {
       throw WebAuthnWebException(
         'deleteAuth',
         'Credential deletion failed. Check rpId domain match and that the credential exists.',
         e,
       );
    }
  }
}

// External JS Function definitions
@JS('register')
external JSPromise _register(JSAny? options);

@JS('sign')
external JSPromise _sign(JSAny? options);

@JS('deleteAuth')
external JSPromise _deleteAuth(JSAny? options);
