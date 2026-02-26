// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'src/exceptions.dart';
import 'src/models.dart';
import 'web_authn_web_platform_interface.dart';

/// A web implementation of the WebAuthnWebPlatform of the WebAuthnWeb plugin.
class WebAuthnWebWeb extends WebAuthnWebPlatform {
  static Completer<void>? _scriptLoadCompleter;
  static bool _scriptInjected = false;

  /// Constructs a WebAuthnWebWeb
  WebAuthnWebWeb();

  static void registerWith(Registrar registrar) {
    WebAuthnWebPlatform.instance = WebAuthnWebWeb(); //Register the instance
  }

  /// Injects the web_authen.js script into the head of the document
  void _injectScript() {
    if (_scriptInjected) return;
    _scriptInjected = true;

    final existing = web.document.querySelector(
      'script[data-web-authn-web="1"]',
    );
    if (existing != null) {
      return;
    }

    final web.HTMLScriptElement script = web.HTMLScriptElement();
    // Using the asset path from the package
    script.src = 'assets/packages/web_authn_web/assets/web_authen.js';
    script.type = 'text/javascript';
    script.defer = true;
    script.setAttribute('data-web-authn-web', '1');
    web.document.head?.append(script);
  }

  Future<void> _ensureScriptLoaded() async {
    if (_hasBridgeFunctions) return;

    final existing = _scriptLoadCompleter;
    if (existing != null) {
      return existing.future;
    }

    final completer = Completer<void>();
    _scriptLoadCompleter = completer;
    _injectScript();

    () async {
      try {
        const maxAttempts = 100; // ~5s
        for (var i = 0; i < maxAttempts; i++) {
          if (_hasBridgeFunctions) {
            if (!completer.isCompleted) completer.complete();
            return;
          }
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
        if (!completer.isCompleted) {
          completer.completeError(
            StateError('web_authen.js did not load in time'),
          );
        }
      } catch (e, st) {
        if (!completer.isCompleted) {
          completer.completeError(e, st);
        }
      } finally {
        if (_scriptLoadCompleter == completer && completer.isCompleted) {
          // Keep completed completer for concurrent callers in same session.
        }
      }
    }();

    return completer.future;
  }

  bool get _hasBridgeFunctions =>
      (web.window as JSObject).has('register') &&
      (web.window as JSObject).has('sign') &&
      (web.window as JSObject).has('deleteAuth');

  @override
  Future<Map<String, dynamic>> register(
    PublicKeyCredentialCreationOptions publicKey,
  ) async {
    try {
      await _ensureScriptLoaded();
      final jsOptions = publicKey.toJson().jsify();
      final result = await _register(jsOptions).toDart;
      return (result.dartify() as Map<Object?, Object?>)
          .cast<String, dynamic>();
    } catch (e) {
      throw WebAuthnWebException(
        'register',
        'Registration failed. Check HTTPS/localhost, rpId domain match, and browser WebAuthn support.',
        e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sign(
    PublicKeyCredentialRequestOptions publicKey,
  ) async {
    try {
      await _ensureScriptLoaded();
      final jsOptions = publicKey.toJson().jsify();
      final result = await _sign(jsOptions).toDart;
      return (result.dartify() as Map<Object?, Object?>)
          .cast<String, dynamic>();
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
      await _ensureScriptLoaded();
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
