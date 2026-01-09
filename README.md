# web_authn_web

A Flutter Web implementation for WebAuthn (Web Authentication API), allowing you to register and authenticate users using passkeys/biometrics.

This package wraps the `web_authen.js` logic and exposes it via a clean, strictly typed Dart API.

## Features

- **Register**: Create a new public key credential.
- **Sign (Login)**: Authenticate using an existing credential.
- **Delete**: Signal deletion of a credential.
- **Typed API**: Use Dart classes like `PublicKeyCredentialCreationOptions` instead of raw Maps.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  web_authn_web:
    path: path/to/web_authn_web
```

## Usage

This package automatically injects the required JavaScript code (`web_authen.js`) into your application.

### Register a Passkey

```dart
import 'package:web_authn_web/web_authn_web.dart';

final webAuthn = WebAuthnWeb();

final options = PublicKeyCredentialCreationOptions(
  rp: RpEntity(name: 'ACME Corp', id: 'example.com'),
  user: UserEntity(
    name: 'user@example.com',
    id: 'CAMW', // base64 encoded id
    displayName: 'User Name',
  ),
  challenge: 'Y2hhbGxlbmdl', // base64 encoded challenge
  pubKeyCredParams: [
    PubKeyCredParam(type: 'public-key', alg: -7), // ES256
  ],
  authenticatorSelection: AuthenticatorSelectionCriteria(
    authenticatorAttachment: 'platform',
  ),
);

try {
  final result = await webAuthn.register(options);
  print('Registration successful: $result');
} catch (e) {
  print('Registration failed: $e');
}
```

### Authenticate (Sign)

```dart
final options = PublicKeyCredentialRequestOptions(
  challenge: 'Y2hhbGxlbmdl', // base64 encoded challenge
  rpId: 'example.com',
  userVerification: 'required',
);

try {
  final result = await webAuthn.sign(options);
  print('Sign successful: $result');
} catch (e) {
  print('Sign failed: $e');
}
```

### Delete Credential

```dart
try {
  await webAuthn.deleteAuth('credentialId', 'rpId');
} catch (e) {
  print('Delete failed: $e');
}
```
